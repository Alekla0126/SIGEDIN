# UCIPS – Unidad de Control Institucional de Procesos y Servicios (Frontend Flutter Web)

## Descripción

Este proyecto es un mockup funcional y navegable del sistema UCIPS, desarrollado en Flutter Web siguiendo Clean Architecture y patrón BLoC. Simula el flujo institucional completo: login, dashboard, gestión documental, turnado, acuse, usuarios, auditoría, etc., usando datos y lógica mock.

## Características principales
- **Arquitectura Clean Architecture**: Separación en core, domain, application, infrastructure y presentation.
- **Gestión de estado con BLoC**.
- **Navegación con go_router** (compatible web).
- **Login simulado** con usuarios mock:
  - `admin@ucips.gob.mx` (Administrador)
  - `auditor@ucips.gob.mx` (Auditor)
  - `gestion@ucips.gob.mx` (Gestión Documental)
  - Contraseña para todos: `admin123`
- **Dashboard institucional** con menú lateral fijo, tarjetas resumen y accesos rápidos.
- **Gestión documental**: registro de documentos, subida de archivos (simulada), consulta, turnado y acuse digital.
- **Gestión de usuarios y bitácora de auditoría** (mock).
- **Diseño responsivo** y compatible con desktop/web.

## Estructura de carpetas
- `lib/core/`: Temas, utilidades, constantes, errores.
- `lib/domain/`: Entidades, repositorios, casos de uso.
- `lib/infrastructure/`: Implementaciones mock de repositorios y datasources.
- `lib/application/`: BLoCs y lógica de aplicación.
- `lib/presentation/`: Páginas, widgets, rutas.

## Instalación y ejecución
1. Instala las dependencias:
   ```sh
   flutter pub get
   ```
2. Ejecuta en modo web:
   ```sh
   flutter run -d chrome
   ```
   o usa VS Code/Futter para lanzar en navegador.

## Pruebas
- Ejecuta los tests de widgets:
  ```sh
  flutter test
  ```

## Notas
- El sistema es solo una simulación visual y de flujo, no hay backend real ni persistencia.
- Los permisos y roles se simulan según el usuario mock autenticado.
- Si tienes problemas de layout, revisa el ancho de la ventana o recarga la app.

---
Desarrollado por la Unidad de Control Institucional de Procesos y Servicios (UCIPS).
