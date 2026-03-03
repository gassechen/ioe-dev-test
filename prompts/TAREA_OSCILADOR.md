================================================================================
MISIÓN: CONTROL DE OSCILADOR NO LINEAL
================================================================================

[OBJETIVO]
Diseñar e implementar un controlador para un sistema dinámico no lineal.
El controlador debe mantener el sistema estable en el punto de equilibrio.

[PAQUETE]
Todo el código se crea en el paquete IICV (NO crear paquetes nuevos).

[ESPECIFICACIÓN DEL SISTEMA]
- Ecuación dinámica: ẍ + 0.2ẋ + 1.5x + 0.3x³ = u
- Variables: x (posición), ẋ (velocidad), u (control)
- Punto de equilibrio: x = 0, ẋ = 0
- Condición inicial: x = 1.0, ẋ = 0.0

[FUNCIÓN DE COSTO (FITNESS)]
Minimizar: J = ∫₀¹⁰ (e² + 0.01u²) dt
- menor J es mejor
- Objetivo: J < 10.0

[IMPLEMENTACIÓN - USAR lisp_assert PARA TODO]

1. Definir constantes:
```lisp
(lisp_assert "(defconstant +dt+ 0.01)")
(lisp_assert "(defconstant +t-final+ 10.0)")
(lisp_assert "(defconstant +damping+ 0.2)")
(lisp_assert "(defconstant +stiffness+ 1.5)")
(lisp_assert "(defconstant +nonlinearity+ 0.3)")
(lisp_assert "(defconstant +u-max+ 10.0)")
(lisp_assert "(defconstant +u-min+ -10.0)")
(lisp_assert "(defconstant +kp+ 5.0)")
(lisp_assert "(defconstant +kd+ 3.0)")
(lisp_assert "(defconstant +ki+ 0.5)")
```

2. Definir funciones:
```lisp
(lisp_assert "(defun compute-dynamics (x x-dot u)
  \"Calcula la aceleración del oscilador no lineal.\"
  (- u (* +damping+ x-dot) (* +stiffness+ x) (* +nonlinearity+ (* x x x))))")

(lisp_assert "(defun simulate (controller-fn)
  \"Simula el oscilador no lineal.\"
  ...)")
```

3. Para ejecutar (NO usa lisp_assert):
```lisp
(lisp_evaluate "(simulate #'controller)")
```

[RESTRICCIONES]
- Usar lisp_assert para definiciones
- Usar lisp_evaluate solo para ejecutar
- Todo en paquete IICV (no crear paquetes nuevos)
- NO escribir archivos al disco (no se puede)

[PERSISTENCIA]
```lisp
(lisp_evaluate "(sb-ext:save-lisp-and-die \"ioe-dev\" :executable t :toplevel #'cl-mcp-server:run-server)")
```

[VERIFICACIÓN]
```lisp
(lisp_evaluate "(iiscv:audit-atomic-history)")
```

================================================================================
FIN DE MISIÓN
================================================================================
