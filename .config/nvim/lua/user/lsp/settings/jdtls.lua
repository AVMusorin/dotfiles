-- Needs a jdtls installation; `cmd` below assumes the `jdtls` launcher script
-- from the Eclipse JDT LS distribution is on $PATH.
return {
  cmd = {
    "jdtls",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "--jvm-arg=-Xmx5g",
  },
  root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
}
