allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.findByName("android")
        if (android != null) {
            // Inject missing namespace for older plugins early
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val currentNamespace = getNamespace.invoke(android)
                if (currentNamespace == null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    val pkg = if (project.name == "on_audio_query_android") {
                        "com.lucasjosino.on_audio_query"
                    } else {
                        "com.pattupetti." + project.name.replace("-", "_").replace(":", "_")
                    }
                    setNamespace.invoke(android, pkg)
                }
            } catch (e: Exception) {
                // ignore
            }
        }
    }

    if (project.name != "app") {
        afterEvaluate {
            if (plugins.hasPlugin("com.android.library")) {
                val android = extensions.findByName("android")
                if (android != null) {
                    try {
                        for (m in android.javaClass.methods) {
                            if (m.name == "setCompileSdk" || m.name == "compileSdkVersion" || m.name == "setCompileSdkVersion") {
                                if (m.parameterTypes.size == 1) {
                                    val pType = m.parameterTypes[0]
                                    if (pType == java.lang.Integer.TYPE || pType == java.lang.Integer::class.java) {
                                        m.invoke(android, 36)
                                        println("Enforced compileSdk 36 for ${project.name}")
                                    }
                                }
                            }
                        }
                    } catch (e: Exception) {
                        // ignore
                    }

                    try {
                        val compileOptions = android.javaClass.getMethod("getCompileOptions").invoke(android)
                        if (compileOptions != null) {
                            compileOptions.javaClass.getMethod("setSourceCompatibility", Any::class.java).invoke(compileOptions, JavaVersion.VERSION_17)
                            compileOptions.javaClass.getMethod("setTargetCompatibility", Any::class.java).invoke(compileOptions, JavaVersion.VERSION_17)
                        }
                    } catch (e: Exception) {
                        // ignore
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
