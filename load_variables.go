package core

import (
        "fmt"
        "os"

        "github.com/spf13/viper"
)

func LoadEnvVariables() {

        viper.SetConfigType("yaml")
        viper.SetConfigFile("/root/osmedeus-base/token/osm-var.yaml")

        err := viper.ReadInConfig()
        if err != nil {
                panic(fmt.Errorf("fatal error config file: %w", err))
        }

        // Load and set variables
        tokens := viper.GetStringMapString("tokens")
        for key, val := range tokens {
                os.Setenv(key, val)
        }

}
