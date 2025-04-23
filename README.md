# Lark - Инструмент для работы с Proto-файлами

Lark - это мощный инструмент для автоматизации работы с proto-файлами в Go-проектах. Он предоставляет комплексное решение для генерации кода, документации и валидации proto-файлов.

## Основные возможности

- ✨ Генерация Go-кода из proto-файлов
- 🌐 Генерация gRPC-кода
- 🔄 Генерация gRPC-Gateway кода
- 📚 Генерация Swagger/OpenAPI документации
- 🔍 Линтинг proto-файлов
- ⚡ Кэширование результатов генерации
- 🏷️ Вставка кастомных тегов в сгенерированные структуры

## Системные требования

- Go 1.22.1+
- Docker
- protoc 26.1+
- protoc-gen-go 1.33.0+
- protoc-gen-go-grpc 1.3.0+
- protoc-gen-doc 1.5.1+
- protoc-gen-grpc-gateway 2.19.1+
- protoc-gen-openapi 2.19.1+
- protoc-go-inject-tag 1.4.0+
- protolint 0.49.4+

## Быстрый старт

### Установка

```bash
git clone <repository-url>
cd <project-directory>
go mod download
```

### Основные команды

```bash
# Полная генерация (линт + генерация + инъекция тегов)
task protogen-generate

# Линтинг proto-файлов
task proto-lint

# Генерация кода
task proto-gen

# Инъекция тегов
task proto-inject
```

## Конфигурация

### Основной конфигурационный файл (lark.yml)

```yaml
vars:
  SWAGGER_TARGET: "/docs"  # Директория для Swagger документации
  SWAGGER_OPTS: "..."      # Опции для генерации Swagger

env:
  PROTOGEN_SRC: "{{.USER_WORKING_DIR}}/api"      # Исходная директория proto-файлов
  PROTOGEN_TARGET: "{{.USER_WORKING_DIR}}/pkg/proto"  # Директория для генерации
```

## Система кэширования

### Как работает кэширование

1. **Создание хешей**:
   - Каждый proto-файл получает уникальный хеш (SHA-256)
   - Хеши сохраняются в `.cache` внутри `PROTOGEN_TARGET`
   - Формат: `<proto-file-name>.hash`

2. **Процесс валидации**:
   - Автоматическая проверка хешей при каждом запуске
   - Генерация только для измененных файлов
   - Оптимизация времени сборки

## Структура проекта

```
lark/
├── Dockerfile           # Docker-образ для генерации
├── docker_build.sh     # Скрипт сборки Docker-образа
├── docker_run.sh       # Скрипт запуска Docker-контейнера
├── lark.yml          # Конфигурация задач
├── .protolint.yaml    # Конфигурация линтера
└── scripts/
    ├── proto_gen.sh   # Скрипт генерации
    ├── proto_lint.sh  # Скрипт линтинга
    ├── proto_inject.sh # Скрипт инъекции тегов
```

## Лицензия

MIT 