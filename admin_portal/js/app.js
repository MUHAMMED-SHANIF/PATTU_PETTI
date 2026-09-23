/**
 * Pattu Petti — Admin Portal Application Controller
 * Handles tab navigation, views rendering, Chart.js, and interactive actions.
 */

document.addEventListener('DOMContentLoaded', async () => {
  initNavigation();
  initModals();
  // Auto-connect to Supabase on load — no manual step needed
  await checkSupabaseConnectionStatus();
  await loadDashboard();
  // Pre-load users in background so the tab is instant when clicked
  window.api.getUsers().then(users => { currentUsers = users; });
});

// ─── Navigation ─────────────────────────────────────────────────────────────
function initNavigation() {
  const navItems = document.querySelectorAll('.nav-item');
  navItems.forEach(item => {
    item.addEventListener('click', async (e) => {
      e.preventDefault();
      const targetView = item.getAttribute('data-view');
      switchView(targetView);
    });
  });
}

async function switchView(viewName) {
  // Update nav active state
  document.querySelectorAll('.nav-item').forEach(item => {
    item.classList.toggle('active', item.getAttribute('data-view') === viewName);
  });

  // Update view sections
  document.querySelectorAll('.view-section').forEach(section => {
    section.classList.remove('active');
  });

  const activeSection = document.getElementById(`view-${viewName}`);
  if (activeSection) {
    activeSection.classList.add('active');
  }

  // Update page title
  const titleMap = {
    dashboard: 'System Overview',
    users: 'User Management',
    premium: 'Premium Requests',
    features: 'Feature Flags & Access',
    audit: 'Admin Audit Trail',
    system: 'Platform Settings',
  };
  document.getElementById('current-page-title').textContent = titleMap[viewName] || 'Admin Portal';

  // Load view data
  switch (viewName) {
    case 'dashboard':
      await loadDashboard();
      break;
    case 'users':
      await loadUsers();
      break;
    case 'premium':
      await loadPremiumRequests();
      break;
    case 'features':
      await loadFeatureFlags();
      break;
    case 'audit':
      await loadAuditLogs();
      break;
    case 'system':
      await loadSystemSettings();
      break;
  }
}

// ─── Connection Status ──────────────────────────────────────────────────────
async function checkSupabaseConnectionStatus() {
  const statusBadge = document.getElementById('connection-badge');
  if (!statusBadge) return;

  if (!window.api.isLive) {
    statusBadge.innerHTML = `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#f59e0b;margin-right:6px;"></span> Demo Mode (Offline)`;
    statusBadge.className = 'badge badge-admin';
    return;
  }

  statusBadge.innerHTML = `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#3b82f6;margin-right:6px;"></span> Checking Supabase...`;

  const probe = await window.api.probeConnection();
  if (probe.online) {
    if (probe.authenticated) {
      statusBadge.innerHTML = `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#22c55e;margin-right:6px;"></span> Supabase: ${probe.email}`;
      statusBadge.className = 'badge badge-active';
      // Update sidebar
      const nameElem = document.getElementById('sidebar-admin-name');
      const avatarElem = document.getElementById('sidebar-admin-avatar');
      if (nameElem && probe.email) nameElem.textContent = probe.email;
      if (avatarElem && probe.email) avatarElem.textContent = probe.email.substring(0, 1).toUpperCase();
    } else {
      statusBadge.innerHTML = `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#22c55e;margin-right:6px;"></span> Connected to Supabase`;
      statusBadge.className = 'badge badge-active';
    }
  } else {
    statusBadge.innerHTML = `<span style="display:inline-block;width:8px;height:8px;border-radius:50%;background:#ef4444;margin-right:6px;"></span> Connection Error`;
    statusBadge.className = 'badge badge-danger';
  }
}

// ─── 1. Dashboard ───────────────────────────────────────────────────────────
let userChartInstance = null;
let activityChartInstance = null;

async function loadDashboard() {
  const stats = await window.api.getDashboardStats();
  document.getElementById('stat-total-users').textContent = stats.totalUsers;
  document.getElementById('stat-premium-users').textContent = stats.premiumUsers;
  const flagElem = document.getElementById('stat-active-flags');
  if (flagElem) flagElem.textContent = stats.activeFlags;
  document.getElementById('stat-pending-requests').textContent = stats.pendingRequests;

  initDashboardCharts();
}

function initDashboardCharts() {
  if (typeof Chart === 'undefined') return;

  // Registration chart
  const ctxUsers = document.getElementById('chart-user-growth')?.getContext('2d');
  if (ctxUsers) {
    if (userChartInstance) userChartInstance.destroy();
    userChartInstance = new Chart(ctxUsers, {
      type: 'line',
      data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
          label: 'Active Listeners',
          data: [65, 80, 78, 105, 130, 155, 142],
          borderColor: '#1db954',
          backgroundColor: 'rgba(29, 185, 84, 0.1)',
          fill: true,
          tension: 0.4,
          borderWidth: 2,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
          x: { grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { color: '#64748b' } },
          y: { grid: { color: 'rgba(255, 255, 255, 0.05)' }, ticks: { color: '#64748b' } }
        }
      }
    });
  }

  // Distribution chart
  const ctxDist = document.getElementById('chart-audio-types')?.getContext('2d');
  if (ctxDist) {
    if (activityChartInstance) activityChartInstance.destroy();
    activityChartInstance = new Chart(ctxDist, {
      type: 'doughnut',
      data: {
        labels: ['Songs', 'Clips', 'Merged', 'Recordings'],
        datasets: [{
          data: [1120, 430, 185, 110],
          backgroundColor: ['#1db954', '#3b82f6', '#f59e0b', '#ec4899'],
          borderWidth: 0,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'bottom', labels: { color: '#94a3b8', font: { size: 11 } } }
        }
      }
    });
  }
}

// ─── 2. Users ───────────────────────────────────────────────────────────────
let currentUsers = [];

async function loadUsers() {
  currentUsers = await window.api.getUsers();
  renderUsersTable(currentUsers);

  const searchInput = document.getElementById('users-search-input');
  if (searchInput) {
    searchInput.oninput = (e) => {
      const q = e.target.value.toLowerCase();
      const filtered = currentUsers.filter(u =>
        (u.username || '').toLowerCase().includes(q) ||
        (u.displayName || '').toLowerCase().includes(q) ||
        (u.email || '').toLowerCase().includes(q)
      );
      renderUsersTable(filtered);
    };
  }
}

function renderUsersTable(users) {
  const tbody = document.getElementById('users-table-body');
  if (!tbody) return;

  if (users.length === 0) {
    tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;color:#64748b;padding:32px;">No users found</td></tr>`;
    return;
  }

  tbody.innerHTML = users.map(user => `
    <tr>
      <td>
        <div style="display:flex;align-items:center;gap:10px;">
          <div class="admin-avatar" style="width:28px;height:28px;font-size:11px;background:#1e293b;">
            ${user.username.substring(0, 2).toUpperCase()}
          </div>
          <div>
            <div style="font-weight:600;">${user.displayName}</div>
            <div style="font-size:11px;color:#64748b;">@${user.username}</div>
          </div>
        </div>
      </td>
      <td>${user.email}</td>
      <td>
        <span class="badge badge-${user.role}">${user.role}</span>
      </td>
      <td>
        ${user.isBanned
          ? '<span class="badge badge-banned">Banned</span>'
          : '<span class="badge badge-active">Active</span>'}
      </td>
      <td style="color:#64748b;">${user.createdAt}</td>
      <td style="text-align:right;white-space:nowrap;">
        <button class="btn btn-secondary" style="padding:5px 12px;font-size:12px;" onclick="viewUser('${user.id}')">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-1px;margin-right:4px;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>View
        </button>
        <button class="btn btn-primary" style="padding:5px 12px;font-size:12px;margin-left:6px;" onclick="editUser('${user.id}')">
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-1px;margin-right:4px;"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>Edit
        </button>
      </td>
    </tr>
  `).join('');
}

window._currentViewUserId = null;

window.viewUser = async (userId) => {
  const user = await window.api.getUserById(userId);
  if (!user) {
    showToast('User not found.');
    return;
  }

  window._currentViewUserId = userId;

  document.getElementById('view-user-avatar').textContent = (user.username || 'U').substring(0, 2).toUpperCase();
  document.getElementById('view-user-display-name').textContent = user.displayName || user.username;
  document.getElementById('view-user-username').textContent = `@${user.username}`;
  
  const roleBadge = document.getElementById('view-user-role-badge');
  roleBadge.innerHTML = `<span class="badge badge-${user.role}">${user.role.toUpperCase()}</span>`;

  document.getElementById('view-user-id').textContent = user.id;
  document.getElementById('view-user-email').textContent = user.email || '—';
  document.getElementById('view-user-phone').textContent = user.phone || '—';
  
  const statusElem = document.getElementById('view-user-status');
  if (user.isBanned) {
    statusElem.innerHTML = `<span class="badge badge-banned">BANNED</span>`;
  } else {
    statusElem.innerHTML = `<span class="badge badge-active">ACTIVE</span>`;
  }

  document.getElementById('view-user-joined').textContent = user.createdAt || '—';
  
  const roleDescMap = {
    admin: 'Full administrator: User management, platform settings, feature flags, role controls',
    privileged: 'Privileged tier: Stem separation, unlimited virtual clips & merges, priority processing',
    normal: 'Standard listener: Local library playback, basic virtual clips (max 10 min), local merging'
  };
  document.getElementById('view-user-role-desc').textContent = roleDescMap[user.role] || 'Standard Access';

  const banSec = document.getElementById('view-user-ban-section');
  const banReason = document.getElementById('view-user-ban-reason');
  if (user.isBanned) {
    banSec.style.display = 'block';
    banReason.textContent = user.banReason || 'Administrative restriction applied without specified note.';
  } else {
    banSec.style.display = 'none';
    banReason.textContent = '';
  }

  document.getElementById('view-user-modal').classList.add('active');
};

window.editUser = async (userId) => {
  const user = await window.api.getUserById(userId);
  if (!user) {
    showToast('User not found.');
    return;
  }

  // Close view modal if it was active
  document.getElementById('view-user-modal').classList.remove('active');

  document.getElementById('edit-user-id').value = user.id;
  document.getElementById('edit-user-display-name').value = user.displayName || '';
  document.getElementById('edit-user-username').value = user.username || '';
  document.getElementById('edit-user-email').value = user.email || '';
  document.getElementById('edit-user-role').value = user.role || 'normal';
  document.getElementById('edit-user-ban-status').value = user.isBanned ? 'banned' : 'active';
  document.getElementById('edit-user-ban-reason').value = user.banReason || '';

  // Reset delete confirmation box
  const initialZone = document.getElementById('delete-zone-initial');
  const confirmZone = document.getElementById('delete-zone-confirm');
  if (initialZone) initialZone.style.display = 'flex';
  if (confirmZone) confirmZone.style.display = 'none';

  const isPrimaryAdmin = user.id === '6f4b1dd6-ce55-4db6-ba31-27b8af8b1720' || user.username === 'shanifp.2004';
  const showDelBtn = document.getElementById('btn-show-delete-confirm');
  if (showDelBtn) {
    if (isPrimaryAdmin) {
      showDelBtn.disabled = true;
      showDelBtn.textContent = 'Admin Protected';
      showDelBtn.style.opacity = '0.5';
      showDelBtn.style.cursor = 'not-allowed';
      showDelBtn.title = 'Primary Super-Admin account cannot be deleted.';
    } else {
      showDelBtn.disabled = false;
      showDelBtn.textContent = 'Delete User';
      showDelBtn.style.opacity = '1';
      showDelBtn.style.cursor = 'pointer';
      showDelBtn.title = '';
    }
  }

  document.getElementById('edit-user-modal').classList.add('active');
};

window.toggleBanUser = async (id, shouldBan) => {
  const reason = shouldBan ? prompt('Enter reason for restriction/ban:') : '';
  if (shouldBan && reason === null) return;

  await window.api.toggleUserBan(id, shouldBan, reason || 'Admin restriction');
  showToast(shouldBan ? 'User banned.' : 'User ban revoked.');
  await loadUsers();
};

// ─── 3. Premium Requests ────────────────────────────────────────────────────
async function loadPremiumRequests() {
  const requests = await window.api.getPremiumRequests();
  const tbody = document.getElementById('premium-table-body');
  if (!tbody) return;

  if (requests.length === 0) {
    tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;color:#64748b;padding:32px;">No pending premium requests</td></tr>`;
    return;
  }

  tbody.innerHTML = requests.map(req => {
    const isPending = req.status === 'pending';
    const isApproved = req.status === 'approved';
    const isRejected = req.status === 'rejected';

    return `
    <tr>
      <td>
        <div style="font-weight:600;color:#f8fafc;">${req.display_name || req.username || 'User'}</div>
        <div style="font-size:12px;color:#94a3b8;">@${req.username || 'user'}</div>
      </td>
      <td style="color:#94a3b8;font-size:13px;">${req.email || '—'}</td>
      <td>
        <span style="font-family:monospace;font-size:13px;color:#38bdf8;font-weight:500;">
          ${req.phone_number && req.phone_number !== '—' ? req.phone_number : '<span style="color:#64748b;">Not provided</span>'}
        </span>
      </td>
      <td>
        <span style="background:rgba(16,185,129,0.15);color:#10b981;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:700;">
          ${req.requested_days || 30} Days
        </span>
      </td>
      <td style="max-width:240px;color:#cbd5e1;font-size:13px;line-height:1.4;">
        ${req.reason || 'No statement provided'}
      </td>
      <td>
        <span class="badge badge-${req.status}">${req.status}</span>
      </td>
      <td style="color:#64748b;font-size:12px;white-space:nowrap;">
        ${req.created_at ? new Date(req.created_at).toLocaleDateString([], { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }) : '—'}
      </td>
      <td style="text-align:right;white-space:nowrap;">
        ${isPending ? `
          <button class="btn btn-primary" style="padding:4px 10px;font-size:12px;" onclick="approvePremiumPrompt('${req.id}', '${req.user_id}', ${req.requested_days || 30}, '@${req.username || 'user'}')">
            Approve
          </button>
          <button class="btn btn-secondary" style="padding:4px 10px;font-size:12px;margin-left:6px;" onclick="rejectPremiumPrompt('${req.id}', '${req.user_id}', '@${req.username || 'user'}')">
            Reject
          </button>
        ` : isApproved ? `
          <span style="color:#10b981;font-size:12px;font-weight:600;">✓ Approved</span>
          ${req.admin_message ? `<div style="font-size:11px;color:#64748b;max-width:140px;overflow:hidden;text-overflow:ellipsis;">${req.admin_message}</div>` : ''}
        ` : `
          <span style="color:#ef4444;font-size:12px;font-weight:600;">✕ Rejected</span>
          ${req.admin_message ? `<div style="font-size:11px;color:#64748b;max-width:140px;overflow:hidden;text-overflow:ellipsis;">${req.admin_message}</div>` : ''}
        `}
      </td>
    </tr>
    `;
  }).join('');
}

window.approvePremiumPrompt = async (requestId, userId, defaultDays, username) => {
  const daysStr = prompt(`Approve Premium for ${username}:\nEnter number of days to grant:`, defaultDays || 30);
  if (daysStr === null) return;
  const days = parseInt(daysStr.trim(), 10);
  if (isNaN(days) || days <= 0) {
    alert('Please enter a valid positive number of days.');
    return;
  }
  const note = prompt(`Enter optional message for ${username}:`, `Welcome to Premium! Granted ${days} days access.`);
  if (note === null) return;

  const ok = await window.api.reviewPremiumRequest(requestId, userId, 'approved', note, days);
  if (ok) {
    showToast(`Premium approved for ${days} days!`);
    await loadPremiumRequests();
  } else {
    alert('Failed to approve request. Please check connection.');
  }
};

window.rejectPremiumPrompt = async (requestId, userId, username) => {
  const note = prompt(`Reject request for ${username}:\nEnter rejection reason:`, 'Requirements not met at this time.');
  if (note === null) return;

  const ok = await window.api.reviewPremiumRequest(requestId, userId, 'rejected', note);
  if (ok) {
    showToast('Request rejected.');
    await loadPremiumRequests();
  } else {
    alert('Failed to reject request. Please check connection.');
  }
};

// ─── 4. Feature Flags ───────────────────────────────────────────────────────
async function loadFeatureFlags() {
  const flags = await window.api.getFeatureFlags();
  const container = document.getElementById('flags-container');
  if (!container) return;

  container.innerHTML = flags.map(f => `
    <div class="metric-card" style="flex-direction:row;align-items:center;justify-content:space-between;padding:18px 24px;">
      <div style="flex:1;margin-right:20px;">
        <div style="font-weight:700;font-size:15px;color:#f8fafc;font-family:monospace;">${f.feature_key}</div>
        <div style="font-size:13px;color:#94a3b8;margin-top:4px;">${f.description || 'System feature flag'}</div>
      </div>
      <label class="switch">
        <input type="checkbox" ${f.enabled ? 'checked' : ''} onchange="toggleFlag('${f.feature_key}', this.checked)">
        <span class="slider"></span>
      </label>
    </div>
  `).join('');
}

window.toggleFlag = async (featureKey, enabled) => {
  await window.api.toggleFeatureFlag(featureKey, enabled);
  showToast(`Feature flag '${featureKey}' ${enabled ? 'enabled' : 'disabled'}.`);
};

// ─── 5. Audit Logs ──────────────────────────────────────────────────────────
async function loadAuditLogs() {
  const logs = await window.api.getAuditLogs();
  const tbody = document.getElementById('audit-table-body');
  if (!tbody) return;

  tbody.innerHTML = logs.map(log => `
    <tr>
      <td style="color:#64748b;font-family:monospace;font-size:12px;">${log.timestamp || log.created_at}</td>
      <td style="font-weight:600;color:#1db954;">${log.action}</td>
      <td>${log.admin || log.profiles?.username || 'Admin'}</td>
      <td>${log.target || log.target_table || '—'}</td>
      <td style="color:#94a3b8;">${log.details || log.reason || JSON.stringify(log.new_value || {})}</td>
    </tr>
  `).join('');
}

// ─── 6. Platform Settings ───────────────────────────────────────────────────
async function loadSystemSettings() {
  const settings = await window.api.getSystemSettings();

  const allowReg = document.getElementById('setting-allow-registration');
  if (allowReg) allowReg.checked = settings.allow_registration?.enabled ?? true;

  const maintMode = document.getElementById('setting-maintenance-mode');
  if (maintMode) maintMode.checked = settings.maintenance_mode?.enabled ?? false;

  const maxClip = document.getElementById('setting-max-clip');
  if (maxClip) maxClip.value = settings.max_clip_duration_seconds?.value ?? 600;

  const maxMerge = document.getElementById('setting-max-merge');
  if (maxMerge) maxMerge.value = settings.max_merge_items?.value ?? 20;

  const announceTitle = document.getElementById('setting-announce-title');
  if (announceTitle) announceTitle.value = settings.active_announcement?.title ?? '';

  const announceBody = document.getElementById('setting-announce-body');
  if (announceBody) announceBody.value = settings.active_announcement?.body ?? '';
}

window.savePlatformSettings = async () => {
  const allowReg = document.getElementById('setting-allow-registration')?.checked ?? true;
  const maintMode = document.getElementById('setting-maintenance-mode')?.checked ?? false;
  const maxClip = parseInt(document.getElementById('setting-max-clip')?.value || 600);
  const maxMerge = parseInt(document.getElementById('setting-max-merge')?.value || 20);
  const announceTitle = document.getElementById('setting-announce-title')?.value || '';
  const announceBody = document.getElementById('setting-announce-body')?.value || '';

  await window.api.updateSystemSetting('allow_registration', { enabled: allowReg });
  await window.api.updateSystemSetting('maintenance_mode', { enabled: maintMode });
  await window.api.updateSystemSetting('max_clip_duration_seconds', { value: maxClip });
  await window.api.updateSystemSetting('max_merge_items', { value: maxMerge });
  await window.api.updateSystemSetting('active_announcement', {
    title: announceTitle,
    body: announceBody,
    show: announceTitle.length > 0
  });

  showToast('Settings saved successfully!');
};

// ─── Modals & UI Helpers ────────────────────────────────────────────────────
function initModals() {
  // Jump from View Modal to Edit Modal
  document.getElementById('btn-jump-to-edit')?.addEventListener('click', () => {
    if (window._currentViewUserId) {
      editUser(window._currentViewUserId);
    }
  });

  // Save changes from Edit User Modal
  document.getElementById('btn-save-edit-user')?.addEventListener('click', async () => {
    const id = document.getElementById('edit-user-id').value;
    const displayName = document.getElementById('edit-user-display-name').value.trim();
    const username = document.getElementById('edit-user-username').value.trim();
    const email = document.getElementById('edit-user-email').value.trim();
    const role = document.getElementById('edit-user-role').value;
    const banStatus = document.getElementById('edit-user-ban-status').value;
    const banReason = document.getElementById('edit-user-ban-reason').value.trim();

    if (!username) {
      showToast('Username cannot be empty.');
      return;
    }

    try {
      const isBanned = banStatus === 'banned';
      await window.api.updateUser({
        id,
        displayName: displayName || username,
        username,
        email,
        role,
        isBanned,
        banReason: isBanned ? banReason : ''
      });

      document.getElementById('edit-user-modal').classList.remove('active');
      showToast(`User @${username} updated successfully.`);
      await loadUsers();
    } catch (err) {
      console.error('Failed to update user:', err);
      showToast('Failed to update user: ' + (err.message || err));
    }
  });

  // Inline Delete Confirmation handlers
  document.getElementById('btn-show-delete-confirm')?.addEventListener('click', (e) => {
    e.preventDefault();
    document.getElementById('delete-zone-initial').style.display = 'none';
    document.getElementById('delete-zone-confirm').style.display = 'flex';
  });

  document.getElementById('btn-cancel-delete-confirm')?.addEventListener('click', (e) => {
    e.preventDefault();
    document.getElementById('delete-zone-confirm').style.display = 'none';
    document.getElementById('delete-zone-initial').style.display = 'flex';
  });

  document.getElementById('btn-confirm-delete-now')?.addEventListener('click', async (e) => {
    e.preventDefault();
    const id = document.getElementById('edit-user-id').value;
    const username = document.getElementById('edit-user-username').value;
    if (!id) return;

    const btn = document.getElementById('btn-confirm-delete-now');
    btn.disabled = true;
    btn.textContent = 'Deleting...';

    try {
      await window.api.deleteUser(id);
      document.getElementById('edit-user-modal').classList.remove('active');
      showToast(`User @${username || 'account'} deleted successfully.`);
      await loadUsers();
    } catch (err) {
      console.error('Delete error:', err);
      showToast('Failed to delete user: ' + (err.message || err));
    } finally {
      btn.disabled = false;
      btn.textContent = 'Yes, Permanently Delete';
    }
  });

  // Config modal (Supabase keys) — button removed but keep handler for safety
  document.getElementById('btn-open-config')?.addEventListener('click', () => {
    const urlEl = document.getElementById('config-url');
    const keyEl = document.getElementById('config-key');
    if (urlEl) urlEl.value = window.api.url;
    if (keyEl) keyEl.value = window.api.apiKey;
    document.getElementById('config-modal').classList.add('active');
  });

  document.getElementById('btn-save-config')?.addEventListener('click', () => {
    const url = document.getElementById('config-url')?.value;
    const key = document.getElementById('config-key')?.value;
    if (url || key) window.api.saveCredentials(url, key);
    document.getElementById('config-modal').classList.remove('active');
    checkSupabaseConnectionStatus();
    showToast('Supabase connection updated.');
    switchView('dashboard');
  });

  // Admin Sign In
  document.getElementById('btn-do-login')?.addEventListener('click', async () => {
    const email = document.getElementById('login-email').value.trim();
    const pass = document.getElementById('login-password').value;
    const errBox = document.getElementById('login-error-msg');

    if (!email || !pass) {
      errBox.textContent = 'Please enter both email and password.';
      errBox.style.display = 'block';
      return;
    }

    const { user, error } = await window.api.adminSignIn(email, pass);
    if (error) {
      errBox.textContent = error;
      errBox.style.display = 'block';
      return;
    }

    errBox.style.display = 'none';
    document.getElementById('sidebar-admin-name').textContent = user.email || 'Admin';
    document.getElementById('sidebar-admin-avatar').textContent = (user.email || 'A').substring(0, 1).toUpperCase();
    document.getElementById('login-modal').classList.remove('active');
    showToast(`Welcome back, ${user.email}!`);
    await loadDashboard();
  });

  // Demo preview button
  document.getElementById('btn-quick-demo')?.addEventListener('click', () => {
    window.api.isLive = false;
    checkSupabaseConnectionStatus();
    document.getElementById('login-modal').classList.remove('active');
    showToast('Operating in Demo / Local Preview Mode.');
  });

  // Admin Logout
  document.getElementById('btn-admin-logout')?.addEventListener('click', async () => {
    await window.api.adminSignOut();
    document.getElementById('sidebar-admin-name').textContent = 'Guest Admin';
    document.getElementById('login-modal').classList.add('active');
    showToast('Signed out of admin console.');
  });

  // Close modals on backdrop click or close button
  document.querySelectorAll('.close-btn, .btn-cancel-modal').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
    });
  });
  document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) {
        overlay.classList.remove('active');
      }
    });
  });
}

let toastTimer = null;
function showToast(message) {
  let toast = document.getElementById('admin-toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'admin-toast';
    toast.style.cssText = `
      position: fixed;
      bottom: 24px;
      right: 24px;
      background: #101118;
      color: #fff;
      padding: 12px 20px;
      border-radius: 10px;
      border: 1px solid rgba(29, 185, 84, 0.4);
      box-shadow: 0 4px 16px rgba(0,0,0,0.6);
      font-size: 13px;
      font-weight: 600;
      z-index: 9999;
      transition: opacity 0.3s, transform 0.3s;
      transform: translateY(20px);
      opacity: 0;
    `;
    document.body.appendChild(toast);
  }

  if (toastTimer) {
    clearTimeout(toastTimer);
  }

  toast.textContent = message;
  toast.style.transform = 'translateY(0)';
  toast.style.opacity = '1';

  toastTimer = setTimeout(() => {
    toast.style.transform = 'translateY(20px)';
    toast.style.opacity = '0';
  }, 3500);
}
