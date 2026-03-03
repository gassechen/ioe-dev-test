================================================================================
MISIÓN: CONTROL DE OSCILADOR NO LINEAL
================================================================================

[OBJETIVO]
Diseñar e implementar un controlador para un sistema dinámico no lineal.
El controlador debe mantener el sistema estable en el punto de equilibrio.

[ESPECIFICACIÓN DEL SISTEMA]
- Ecuación dinámica: ẍ + 0.2ẋ + 1.5x + 0.3x³ = u
- Variables: x (posición), ẋ (velocidad), u (control)
- Punto de equilibrio: x = 0, ẋ = 0
- Condición inicial: x = 1.0, ẋ = 0.0

[FUNCIÓN DE COSTO (FITNESS)]
Minimizar: J = ∫₀¹⁰ (e² + 0.01u²) dt

Donde:
- e = error = 0 - x (deseamos que x → 0)
- u = señal de control
- NOTA: menor J es mejor

[CRITERIOS DE ÉXITO]
- J < 10.0 (objetivo)
- El sistema debe converger a x ≈ 0
- La señal de control debe estar limitada: |u| ≤ 10

[IMPLEMENTACIÓN REQUERIDA]

1. SIMULADOR (obligatorio)
   - Integrar la dinámica usando método de Euler
   - dt = 0.01, t_final = 10.0
   - Calcular el costo J

2. CONTROLADOR (diseñar)
   - Función: (defun controller (error integral x-dot) ...)
   - Operadores permitidos: + - * / exp log sin cos tanh
   - NO hardcodear ganancias externas
   - saturar u entre -10 y 10

[EJEMPLO DE SIMULADOR]
(defun simulate (controller-fn)
  (let ((x 1.0) (x-dot 0.0) (integral 0.0) (cost 0.0))
    (loop for t from 0 to 10 by 0.01
          do (let* ((error (- 0 x))
                    (u (funcall controller-fn error integral x-dot)))
               (setf u (max -10 (min 10 u)))  ; saturación
               (incf integral (* 0.01 error))
               (let ((x-ddot (- u (* 0.2 x-dot) (* 1.5 x) (* 0.3 (* x x x)))))
                 (incf x-dot (* 0.01 x-ddot))
                 (incf x (* 0.01 x-dot))
                 (incf cost (* 0.01 (+ (* error error) (* 0.01 u u)))))))
    cost))

[FORMATO DE ENTREGA]
1. Paquete: IOE-CONTROL-OSCILADOR
2. Funciones:
   - simulate (el simulador)
   - fitness (retorna J)
   - controller (tu controlador)
3. Evaluar: (fitness #'controller)
4. Reportar: valor de J obtenido

[RESTRICCIONES]
- El controlador debe ser continuo
- No usar funciones discretas
- Usar aritmética de punto flotante
- Incluir docstring técnica

[PERSISTENCIA]
Cuando hayas completado la misión y quieras guardar el conocimiento:

```lisp
;; Guarda la imagen ACTUAL con todo el conocimiento en memoria
;; Sobrescribe ioe-dev con el nuevo estado

(lisp_evaluate "(sb-ext:save-lisp-and-die \"ioe-dev\" :executable t :toplevel #'cl-mcp-server:run-server)")
```

Esto guardará:
- El paquete IOE-CONTROL-OSCILADOR
- Todas las funciones definidas
- El grafo de IISCV con los commits

La próxima vez que ejecutes ./ioe-dev, tendrás todo esto disponible.

[VERIFICACIÓN]
Para verificar que el código fue creado correctamente y no hay trampas,
exportá el código fuente antes de guardar:

```lisp
;; Exporta el código a archivos .lisp
(lisp_evaluate "(iiscv:save-audit-vault \"auditoria.txt\")")
(lisp_evaluate "(iiscv:dump-source-code)")

```

Esto te permite verificar que las funciones existen y tienen el código correcto.

================================================================================
FIN DE MISIÓN
================================================================================
