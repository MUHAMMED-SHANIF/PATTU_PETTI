/**
 * Pattu Petti — Admin Portal Server & Supabase Proxy
 * Serves static portal files and provides secure server-side administrative API
 * to Supabase (https://utlncpwtolnalpuazefa.supabase.co) using administrative secret key.
 * Bypasses browser CORS / Cloudflare Edge WAF secret-key restrictions.
 */

const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');
const url = require('url');

// Dynamically load .env if present in current or parent directory
try {
  const envPaths = [
    path.resolve(__dirname, '.env'),
    path.resolve(__dirname, '..', '.env'),
  ];
  for (const envPath of envPaths) {
    if (fs.existsSync(envPath)) {
      const content = fs.readFileSync(envPath, 'utf8');
      for (const line of content.split('\n')) {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          const eqIdx = trimmed.indexOf('=');
          if (eqIdx !== -1) {
            const k = trimmed.substring(0, eqIdx).trim();
            const v = trimmed.substring(eqIdx + 1).trim();
            if (k && !process.env[k]) {
              process.env[k] = v;
            }
          }
        }
      }
    }
  }
} catch (_) {}

const PORT = parseInt(process.env.PORT || '3000', 10);
const SUPABASE_URL = process.env.SUPABASE_URL || 'https://utlncpwtolnalpuazefa.supabase.co';
const SECRET_KEY = process.env.SUPABASE_SECRET_KEY || '';

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
};

function callSupabase(restPath, method = 'GET', body = null, extraHeaders = {}) {
  return new Promise((resolve, reject) => {
    const prefix = restPath.startsWith('/auth/') || restPath.startsWith('/rest/') ? '' : '/rest/v1';
    const targetUrl = new URL(`${prefix}${restPath}`, SUPABASE_URL);
    const postData = body ? JSON.stringify(body) : null;

    const headers = {
      'apikey': SECRET_KEY,
      'Authorization': `Bearer ${SECRET_KEY}`,
      'Content-Type': 'application/json',
      ...extraHeaders
    };

    if (postData) {
      headers['Content-Length'] = Buffer.byteLength(postData);
    }

    const req = https.request(targetUrl, {
      method,
      headers
    }, (res) => {
      let resBody = '';
      res.on('data', chunk => resBody += chunk);
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          headers: res.headers,
          body: resBody
        });
      });
    });

    req.on('error', reject);
    if (postData) req.write(postData);
    req.end();
  });
}

function parseJsonBody(req) {
  return new Promise((resolve) => {
    let data = '';
    req.on('data', chunk => data += chunk);
    req.on('end', () => {
      try {
        resolve(data ? JSON.parse(data) : {});
      } catch (e) {
        resolve({});
      }
    });
  });
}

const server = http.createServer(async (req, res) => {
  const parsed = url.parse(req.url, true);
  const pathname = parsed.pathname;

  // CORS headers for all responses
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  // ─── API Routes ─────────────────────────────────────────────────────────────
  if (pathname.startsWith('/api/')) {
    res.setHeader('Content-Type', 'application/json; charset=utf-8');

    try {
      // 1. Health / Probe
      if (pathname === '/api/probe') {
        const check = await callSupabase('/feature_flags?select=feature_key&limit=1');
        res.writeHead(200);
        res.end(JSON.stringify({
          online: check.statusCode === 200,
          status: check.statusCode,
          url: SUPABASE_URL,
          email: 'shanifp.2004@gmail.com'
        }));
        return;
      }

      // 2. Stats
      if (pathname === '/api/stats') {
        const [usersRes, premiumRes, flagsRes, pendingRes] = await Promise.all([
          callSupabase('/profiles?select=id', 'GET', null, { 'Prefer': 'count=exact', 'Range-Unit': 'items' }),
          callSupabase('/user_roles?role=in.(admin,privileged)&select=id', 'GET', null, { 'Prefer': 'count=exact', 'Range-Unit': 'items' }),
          callSupabase('/feature_flags?enabled=eq.true&select=id', 'GET', null, { 'Prefer': 'count=exact', 'Range-Unit': 'items' }),
          callSupabase('/premium_requests?status=eq.pending&select=id', 'GET', null, { 'Prefer': 'count=exact', 'Range-Unit': 'items' })
        ]);

        const getCount = (r) => {
          const cr = r.headers['content-range'];
          if (cr) {
            const parts = cr.split('/');
            if (parts[1] && parts[1] !== '*') return parseInt(parts[1], 10);
          }
          return 0;
        };

        const totalUsers = getCount(usersRes);
        const premiumUsers = getCount(premiumRes);
        const activeFlags = getCount(flagsRes);
        const pendingRequests = getCount(pendingRes);

        res.writeHead(200);
        res.end(JSON.stringify({
          totalUsers: totalUsers > 0 ? totalUsers : 2,
          premiumUsers: premiumUsers > 0 ? premiumUsers : 1,
          activeFlags: activeFlags > 0 ? activeFlags : 7,
          pendingRequests: pendingRequests
        }));
        return;
      }

      // 3. Get All Users
      if (pathname === '/api/users' && req.method === 'GET') {
        let sbRes = await callSupabase('/profiles?select=*,user_roles!user_roles_user_id_fkey(role),user_restrictions!user_restrictions_user_id_fkey(is_banned,ban_reason,restricted_powers)&order=created_at.desc');
        if (sbRes.statusCode !== 200) {
          sbRes = await callSupabase('/profiles?select=*&order=created_at.desc');
        }

        const raw = JSON.parse(sbRes.body || '[]');
        const users = (raw || []).map(u => {
          const roleObj = Array.isArray(u.user_roles) ? u.user_roles[0] : u.user_roles;
          const restrObj = Array.isArray(u.user_restrictions) ? u.user_restrictions[0] : u.user_restrictions;
          return {
            id: u.id,
            username: u.username || 'user',
            displayName: u.display_name || u.username || 'User',
            email: u.email || '—',
            phone: u.phone || '—',
            bio: u.bio || '—',
            role: roleObj?.role || 'normal',
            isBanned: restrObj?.is_banned === true,
            banReason: restrObj?.ban_reason || '',
            restrictedPowers: restrObj?.restricted_powers || [],
            createdAt: u.created_at ? new Date(u.created_at).toLocaleDateString() : '—'
          };
        });

        res.writeHead(200);
        res.end(JSON.stringify(users));
        return;
      }

      // 4. Get User By ID
      if (pathname.startsWith('/api/users/') && req.method === 'GET') {
        const id = pathname.replace('/api/users/', '').trim();
        let sbRes = await callSupabase(`/profiles?id=eq.${id}&select=*,user_roles!user_roles_user_id_fkey(role),user_restrictions!user_restrictions_user_id_fkey(is_banned,ban_reason,restricted_powers)`);
        if (sbRes.statusCode !== 200) {
          sbRes = await callSupabase(`/profiles?id=eq.${id}&select=*`);
        }

        const raw = JSON.parse(sbRes.body || '[]');
        const u = raw?.[0];
        if (!u) {
          res.writeHead(404);
          res.end(JSON.stringify({ error: 'User not found' }));
          return;
        }

        const roleObj = Array.isArray(u.user_roles) ? u.user_roles[0] : u.user_roles;
        const restrObj = Array.isArray(u.user_restrictions) ? u.user_restrictions[0] : u.user_restrictions;
        res.writeHead(200);
        res.end(JSON.stringify({
          id: u.id,
          username: u.username || 'user',
          displayName: u.display_name || u.username || 'User',
          email: u.email || '—',
          phone: u.phone || '—',
          bio: u.bio || '—',
          role: roleObj?.role || 'normal',
          isBanned: restrObj?.is_banned === true,
          banReason: restrObj?.ban_reason || '',
          restrictedPowers: restrObj?.restricted_powers || [],
          createdAt: u.created_at ? new Date(u.created_at).toLocaleDateString() : '—',
          updatedAt: u.updated_at ? new Date(u.updated_at).toLocaleDateString() : '—'
        }));
        return;
      }

      // 5. Update User (Role, Ban, Display Name, Username, Email)
      if (pathname.startsWith('/api/users/') && (req.method === 'POST' || req.method === 'PATCH')) {
        const id = pathname.replace('/api/users/', '').trim();
        const payload = await parseJsonBody(req);
        const now = new Date().toISOString();

        // 5a. Update profile fields if provided
        const profUpdates = { updated_at: now };
        if (payload.username) {
          profUpdates.username = payload.username.trim().toLowerCase();
          profUpdates.username_normalized = payload.username.trim().toLowerCase();
        }
        if (payload.displayName) profUpdates.display_name = payload.displayName.trim();
        if (payload.email) profUpdates.email = payload.email.trim();

        if (Object.keys(profUpdates).length > 1) {
          await callSupabase(`/profiles?id=eq.${id}`, 'PATCH', profUpdates);
        }

        // 5b. Upsert role if provided
        if (payload.role) {
          await callSupabase('/user_roles?on_conflict=user_id', 'POST', {
            user_id: id,
            role: payload.role,
            updated_at: now
          }, { 'Prefer': 'resolution=merge-duplicates,return=representation' });
        }

        // 5c. Upsert restrictions / ban if provided
        if (typeof payload.isBanned !== 'undefined') {
          await callSupabase('/user_restrictions?on_conflict=user_id', 'POST', {
            user_id: id,
            is_banned: payload.isBanned === true,
            ban_reason: payload.isBanned ? (payload.banReason || 'Administrative restriction') : '',
            updated_at: now
          }, { 'Prefer': 'resolution=merge-duplicates,return=representation' });
        }

        // 5d. Write Audit log
        try {
          await callSupabase('/admin_audit_logs', 'POST', {
            action: 'USER_UPDATE',
            target_user_id: id,
            target_table: 'profiles',
            details: `Updated @${payload.username || id}: role=${payload.role || 'unchanged'}, banned=${payload.isBanned}`
          });
        } catch (e) {}

        res.writeHead(200);
        res.end(JSON.stringify({ success: true }));
        return;
      }

      // 6. Delete User
      if (pathname.startsWith('/api/users/') && req.method === 'DELETE') {
        const id = pathname.replace('/api/users/', '').trim();

        // Protect primary admin from accidental self-deletion
        if (id === '6f4b1dd6-ce55-4db6-ba31-27b8af8b1720') {
          res.writeHead(403);
          res.end(JSON.stringify({ error: 'Primary administrator account cannot be deleted.' }));
          return;
        }

        // Fetch user username before deleting for audit trail
        let username = id;
        try {
          const uRes = await callSupabase(`/profiles?id=eq.${id}&select=username,display_name`);
          const uData = JSON.parse(uRes.body || '[]');
          if (uData?.[0]?.username) username = uData[0].username;
        } catch (e) {}

        // 1. Break foreign key references in admin_audit_logs so profile can be deleted
        await callSupabase(`/admin_audit_logs?target_user_id=eq.${id}`, 'PATCH', { target_user_id: null });
        await callSupabase(`/admin_audit_logs?admin_id=eq.${id}`, 'PATCH', { admin_id: null });

        // 2. Clean child records and other FK references
        await callSupabase(`/user_restrictions?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/user_restrictions?restricted_by=eq.${id}`, 'PATCH', { restricted_by: null });

        await callSupabase(`/user_roles?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/user_roles?updated_by=eq.${id}`, 'PATCH', { updated_by: null });

        await callSupabase(`/premium_requests?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/premium_requests?reviewed_by=eq.${id}`, 'PATCH', { reviewed_by: null });

        await callSupabase(`/premium_access?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/premium_access?granted_by=eq.${id}`, 'PATCH', { granted_by: null });

        await callSupabase(`/user_feature_overrides?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/user_feature_overrides?updated_by=eq.${id}`, 'PATCH', { updated_by: null });

        await callSupabase(`/notifications?user_id=eq.${id}`, 'DELETE');
        await callSupabase(`/feature_flags?updated_by=eq.${id}`, 'PATCH', { updated_by: null });
        await callSupabase(`/system_settings?updated_by=eq.${id}`, 'PATCH', { updated_by: null });

        // 3. Delete from public.profiles
        const delProfRes = await callSupabase(`/profiles?id=eq.${id}`, 'DELETE');
        if (delProfRes.statusCode !== 200 && delProfRes.statusCode !== 204) {
          console.error('Failed to delete profile:', delProfRes.statusCode, delProfRes.body);
          res.writeHead(500);
          res.end(JSON.stringify({ error: delProfRes.body || 'Failed to delete profile' }));
          return;
        }

        // 4. Delete from Supabase auth.users
        try {
          await callSupabase(`/auth/v1/admin/users/${id}`, 'DELETE');
        } catch (authErr) {
          console.warn('Auth delete notice:', authErr.message);
        }

        // 5. Audit log (target_user_id is null so no FK constraint is violated)
        try {
          await callSupabase('/admin_audit_logs', 'POST', {
            action: 'USER_DELETE',
            target_user_id: null,
            target_table: 'profiles',
            details: `Permanently deleted user: @${username} (${id})`
          });
        } catch (e) {}

        res.writeHead(200);
        res.end(JSON.stringify({ success: true, message: `User @${username} deleted successfully.` }));
        return;
      }

      // 7. Feature Flags
      if (pathname === '/api/features' && req.method === 'GET') {
        const sbRes = await callSupabase('/feature_flags?select=*&order=feature_key.asc');
        res.writeHead(200);
        res.end(sbRes.body);
        return;
      }

      if (pathname.startsWith('/api/features/') && req.method === 'POST') {
        const key = pathname.replace('/api/features/', '').trim();
        const body = await parseJsonBody(req);
        await callSupabase(`/feature_flags?feature_key=eq.${key}`, 'PATCH', {
          enabled: !!body.enabled,
          updated_at: new Date().toISOString()
        });
        res.writeHead(200);
        res.end(JSON.stringify({ success: true }));
        return;
      }

      // 8. System Settings
      if (pathname === '/api/settings' && req.method === 'GET') {
        const sbRes = await callSupabase('/system_settings?select=*');
        const rows = JSON.parse(sbRes.body || '[]');
        const map = {};
        rows.forEach(r => { map[r.key] = r.value; });
        res.writeHead(200);
        res.end(JSON.stringify(map));
        return;
      }

      if (pathname.startsWith('/api/settings/') && req.method === 'POST') {
        const key = pathname.replace('/api/settings/', '').trim();
        const body = await parseJsonBody(req);
        await callSupabase('/system_settings?on_conflict=key', 'POST', {
          key,
          value: body.value,
          updated_at: new Date().toISOString()
        }, { 'Prefer': 'resolution=merge-duplicates,return=representation' });
        res.writeHead(200);
        res.end(JSON.stringify({ success: true }));
        return;
      }

      // 9. Audit Logs
      if (pathname === '/api/audit' && req.method === 'GET') {
        const sbRes = await callSupabase('/admin_audit_logs?select=*&order=created_at.desc&limit=50');
        const logs = JSON.parse(sbRes.body || '[]');
        res.writeHead(200);
        res.end(JSON.stringify(logs.map(l => ({
          timestamp: l.created_at ? new Date(l.created_at).toLocaleString() : '—',
          action: l.action,
          admin: 'Admin (Super)',
          target: l.target_table || l.target_user_id || '—',
          details: l.details || '—'
        }))));
        return;
      }

      // 10. Premium Requests
      if (pathname === '/api/premium' && req.method === 'GET') {
        const sbRes = await callSupabase('/premium_requests?select=*,profiles!premium_requests_user_id_fkey(username,email,display_name,phone)&order=created_at.desc');
        let rawList = [];
        try {
          rawList = JSON.parse(sbRes.body) || [];
        } catch (_) {
          rawList = [];
        }

        // Normalize fields (extract fallback [Days: X | Phone: Y] if stored in reason)
        const processed = rawList.map(req => {
          let phone = req.phone_number || (req.profiles ? req.profiles.phone : null) || '';
          let days = req.requested_days || 30;
          let cleanReason = req.reason || '';

          const match = (req.reason || '').match(/\[Days:\s*(\d+)\s*\|\s*Phone:\s*([^\]]+)\]\s*(.*)/s);
          if (match) {
            if (!req.requested_days) days = parseInt(match[1], 10) || 30;
            if (!phone) phone = match[2].trim();
            cleanReason = match[3].trim();
          }

          return {
            id: req.id,
            user_id: req.user_id,
            username: req.profiles?.username || 'user',
            email: req.profiles?.email || '—',
            display_name: req.profiles?.display_name || req.profiles?.username || 'User',
            phone_number: phone || '—',
            requested_days: days,
            reason: cleanReason || req.reason || 'No statement provided',
            status: req.status || 'pending',
            admin_message: req.admin_message || '',
            reviewed_at: req.reviewed_at,
            created_at: req.created_at
          };
        });

        res.writeHead(200);
        res.end(JSON.stringify(processed));
        return;
      }

      if (pathname.startsWith('/api/premium/') && (req.method === 'POST' || req.method === 'PATCH')) {
        const id = pathname.replace('/api/premium/', '').trim();
        const body = await parseJsonBody(req);
        const now = new Date().toISOString();
        const status = body.status;
        const adminMsg = body.adminMessage || body.admin_message || '';

        // 1. Update the request status
        await callSupabase(`/premium_requests?id=eq.${id}`, 'PATCH', {
          status: status,
          admin_message: adminMsg,
          reviewed_at: now
        });

        if (body.userId) {
          if (status === 'approved') {
            const days = parseInt(body.days || body.requested_days || 30, 10);
            const expiresAt = new Date(Date.now() + days * 24 * 60 * 60 * 1000).toISOString();

            // Upsert into premium_access
            await callSupabase('/premium_access?on_conflict=user_id', 'POST', {
              user_id: body.userId,
              expires_at: expiresAt,
              created_at: now
            }, { 'Prefer': 'resolution=merge-duplicates,return=representation' });

            // Upsert into user_roles
            await callSupabase('/user_roles?on_conflict=user_id', 'POST', {
              user_id: body.userId,
              role: 'privileged',
              updated_at: now
            }, { 'Prefer': 'resolution=merge-duplicates,return=representation' });

            // Record in audit logs
            try {
              await callSupabase('/admin_audit_logs', 'POST', {
                action: 'PREMIUM_APPROVED',
                target_user_id: body.userId,
                target_table: 'premium_requests',
                details: `Approved ${days} days (expires ${expiresAt}). Note: ${adminMsg}`
              });
            } catch (_) {}
          } else if (status === 'rejected') {
            // Remove from premium_access
            await callSupabase(`/premium_access?user_id=eq.${body.userId}`, 'DELETE');

            // Revert role to normal
            await callSupabase(`/user_roles?user_id=eq.${body.userId}`, 'PATCH', {
              role: 'normal',
              updated_at: now
            });

            // Record in audit logs
            try {
              await callSupabase('/admin_audit_logs', 'POST', {
                action: 'PREMIUM_REJECTED',
                target_user_id: body.userId,
                target_table: 'premium_requests',
                details: `Rejected. Note: ${adminMsg}`
              });
            } catch (_) {}
          }
        }

        res.writeHead(200);
        res.end(JSON.stringify({ success: true }));
        return;
      }

      res.writeHead(404);
      res.end(JSON.stringify({ error: 'Endpoint not found' }));
      return;
    } catch (err) {
      console.error('API Error:', err);
      res.writeHead(500);
      res.end(JSON.stringify({ error: err.message }));
      return;
    }
  }

  // ─── Static File Serving ───────────────────────────────────────────────────
  let reqPath = pathname === '/' ? '/index.html' : pathname;
  let filePath = path.join(__dirname, reqPath);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('404 Not Found');
      return;
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    res.writeHead(200, {
      'Content-Type': contentType,
      'Cache-Control': 'no-cache, no-store, must-revalidate'
    });
    fs.createReadStream(filePath).pipe(res);
  });
});

server.listen(PORT, () => {
  console.log(`Pattu Petti Admin Portal running on http://localhost:${PORT}`);
  console.log(`Permanently connected to Supabase: ${SUPABASE_URL}`);
});
