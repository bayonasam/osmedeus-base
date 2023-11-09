package main

import (
        "github.com/j3ssie/osmedeus/cmd"
        "github.com/j3ssie/osmedeus/core"
)

func main() {
        core.LoadEnvVariables()
        cmd.Execute()
}
