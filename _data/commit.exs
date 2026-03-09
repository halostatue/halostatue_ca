"git"
|> System.cmd(["rev-parse", "--short", "HEAD"])
|> elem(0)
|> String.trim()
