;; build-ioe.lisp

;; 1. Cargar Quicklisp manualmente (ya que no cargamos el init del usuario)
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (if (probe-file quicklisp-init)
      (load quicklisp-init)
      (error "No se encontró Quicklisp en ~A" quicklisp-init)))

;; 2. Cargar los sistemas
(format t "~%[BUILD] Cargando sistemas...~%")
(ql:quickload :cl-mcp-server)
(ql:quickload :iiscv)

;; 3. Registrar la herramienta COMMIT en el servidor MCP
(in-package :cl-mcp-server.tools)

;; Tool: lisp_commit
;; Usa make-assert que:
;; 1. Audita con LISA
;; 2. Si score ≤ 10 → hace commit automático via rule-finalize-commit-to-graph
;; 3. Si score > 10 → NO entra al grafo
(register-tool
 "lisp_commit"
 "Audita código usando IISCV + LISA. Si pasa el filtro de calidad (score ≤ 10), se registra automáticamente."
 '(("type" . "object")
   ("required" . ("code"))
   ("properties" . (("code" . (("type" . "string")
                               ("description" . "Código Lisp a auditar y registrar (defun, defmacro, defvar, etc.)"))))))
 (lambda (args session)
   (declare (ignore session))
   (let* ((code-str (cdr (assoc "code" args :test #'string=)))
          (form (read-from-string code-str)))
     (with-output-to-string (*standard-output*)
       (handler-case
           (iiscv:make-assert form)
         (error (e) 
           (format t "ERROR en auditoría: ~A" e)))))))

;; Tool: lisp_evaluate
;; Para evaluar expresiones SIN auditoría (tests, debugging, cálculos)
(register-tool
 "lisp_evaluate"
 "Evalúa expresiones Lisp sin auditoría (para tests, debugging, cálculos)."
 '(("type" . "object")
   ("required" . ("code"))
   ("properties" . (("code" . (("type" . "string")
                               ("description" . "Expresión Lisp a evaluar"))))))
 (lambda (args session)
   (declare (ignore session))
   (let* ((code-str (cdr (assoc "code" args :test #'string=)))
          (form (read-from-string code-str)))
     (with-output-to-string (*standard-output*)
       (handler-case
           (let ((result (eval form)))
             (unless (eq result :no-print)
               (print result)))
         (error (e) 
           (format t "ERROR: ~A" e)))))))

;; 4. Volcar la imagen con el TOPLEVEL correcto
(format t "~%[BUILD] Generando binario industrial: ioe-dev...~%")

(sb-ext:save-lisp-and-die "ioe-dev" 
                         :executable t 
                         :toplevel (find-symbol "RUN-SERVER" :cl-mcp-server))
