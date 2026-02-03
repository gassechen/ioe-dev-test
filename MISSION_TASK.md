# DIRECTIVA DE MISIÓN: [ID_PROYECTO_001]

## 1. OBJETIVO DE INGENIERÍA
Construir un módulo de [Nombre del Sistema] que sea modular, persistente y auditado. El resultado final debe ser una API exportada y probada.

## 2. BACKLOG TÉCNICO (Secuencia Obligatoria)
1. **Fase de Preparación**:
   - [ ] Identificar y cargar dependencias externas mediante `ql:quickload`.
   - [ ] Crear el paquete `[NOMBRE-PAQUETE]` con sus exports definidos.
   - [ ] Validar la creación del espacio de nombres con `lisp_commit`.

2. **Fase de Construcción**:
   - [ ] Implementar la lógica de negocio (Funciones/Macros) dentro del paquete.
   - [ ] Asegurar que cada definición pase el filtro de aridad e integridad de `iiscv`.

3. **Fase de Certificación**:
   - [ ] Definir la suite de tests unitarios usando el framework nativo de `iiscv`.
   - [ ] Ejecutar la batería de tests y verificar el éxito total (Pass: 100%).
   - [ ] Ejecutar auditoría lógica de LISA para asegurar nota ISO 25000.

4. **Fase de Entrega**:
   - [ ] Exportar el código fuente (`.lisp`) mediante las funciones de `iiscv`.
   - [ ] Realizar Snapshot del sistema (`save-lisp-and-die`).

## 3. RESTRICCIONES DE DOMINIO ESPECÍFICAS
- [Ej: "El sistema no debe usar variables globales fuera del paquete"]
- [Ej: "El manejo de errores debe ser mediante el sistema de condiciones de CL"]
