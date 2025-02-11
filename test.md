erDiagram
    RESIDENCIA ||--o{ HABITACION : tiene
    RESIDENCIA ||--o{ FOTO : tiene
    RESIDENCIA ||--o{ RESIDENCIA_ADMISION : tiene
    RESIDENCIA ||--o{ RESIDENCIA_PROFESIONAL : tiene
    RESIDENCIA ||--o{ USUARIO : gestiona
    RESIDENCIA ||--|| INSTALACIONES : tiene
    RESIDENCIA ||--|| CERTIFICACIONES : tiene
    RESIDENCIA ||--o{ RESIDENCIA_SERVICIO : tiene
    DIRECCION ||--|| RESIDENCIA : tiene

    ADMISION ||--o{ RESIDENCIA_ADMISION : tiene
    PROFESIONAL ||--o{ RESIDENCIA_PROFESIONAL : tiene
    SERVICIO ||--o{ RESIDENCIA_SERVICIO : tiene

    RESIDENCIA {
        int id PK
        string nombre
        string tipo_edificio
        string mas_informacion
        string porque_elegirnos
        string ratio_personal
        string titulacion_director
        string sistema_precios
        boolean financiacion_publica_hombre
        boolean financiacion_publica_mujer
        string grupo
    }

    DIRECCION {
        int id PK
        int residencia_id FK
        string direccion
        string ciudad
        string codigo_postal
        string provincia
        string comunidad_autonoma
    }

    HABITACION {
        int id PK
        int residencia_id FK
        string tipo
        boolean tiene_bano
        string genero
        decimal precio
    }

    INSTALACIONES {
        int id PK
        int residencia_id FK
        boolean parking
        boolean piscina
        int plazas_totales
        boolean cocina_propia
        int superficie_residente
        boolean transporte_publico
        boolean zona_verde
    }

    CERTIFICACIONES {
        int id PK
        int residencia_id FK
        string ley_dependencia
        string calidad
        string comite_etica
        string otras
        string politica_contenciones
    }

    FOTO {
        int id PK
        int residencia_id FK
        string descripcion
        string url
    }

    USUARIO {
        int id PK
        int residencia_id FK
        string nombre
        string email
        string password
        string rol
    }

    ADMISION {
        int id PK
        string tipo
    }

    PROFESIONAL {
        int id PK
        string tipo
    }

    SERVICIO {
        int id PK
        string nombre
    }

    RESIDENCIA_SERVICIO {
        int residencia_id FK
        int servicio_id FK
        string tipo_precio
    }

    RESIDENCIA_ADMISION {
        int residencia_id FK
        int admision_id FK
    }

    RESIDENCIA_PROFESIONAL {
        int residencia_id FK
        int profesional_id FK
    }
