package core

import (
        "fmt"
        "os"

        "github.com/spf13/viper"
)

func LoadEnvVariables() {

        // Cargar configuración desde el archivo .yaml
        viper.SetConfigType("yaml") // o viper.SetConfigName("config")
        viper.AddConfigPath("/root/osmedeus-base/token/")    // Aquí asumimos que el archivo .yaml está en el mismo directorio
        viper.SetConfigFile("/root/osmedeus-base/token/osm-var.yaml") // Aquí asumimos que tu archivo se llama config.yaml

        err := viper.ReadInConfig()
        if err != nil {
                panic(fmt.Errorf("fatal error config file: %w", err))
        }

        // Leer y configurar las variables de entorno desde la sección de tokens
        tokens := viper.GetStringMapString("tokens")
        for key, val := range tokens {
                os.Setenv(key, val)
        }

}
