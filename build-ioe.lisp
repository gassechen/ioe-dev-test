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

(register-tool
 "commit"
 "Audita, registra y evalúa código usando la lógica de iiscv-repl."
 '(("type" . "object")
   ("required" . ("code"))
   ("properties" . (("code" . (("type" . "string")
                               ("description" . "Código Lisp"))))))
 (lambda (args session)
   (declare (ignore session))
   (let* ((code-str (cdr (assoc "code" args :test #'string=)))
          (form (read-from-string code-str)))
     ;; Redirigimos el output para que el Agente reciba lo que el REPL imprimiría
     (with-output-to-string (*standard-output*)
       (handler-case
           (progn
             ;; USAMOS TU LÓGICA DE REPL:
             ;; 1. Revisamos si es una forma para commitear
             (when (iiscv::get-commit-type form)
               ;; 2. Commiteamos la forma fuente
               (iiscv:make-atomic-commit form))
             
             ;; 3. Evaluamos la forma (para que exista en RAM)
             (let ((result (eval form)))
               (unless (eq result :no-print)
                 (print result))
               (format t "~%[IISCV] Código integrado exitosamente.")))
         (error (e) (format t "ERROR: ~A" e)))))))

;; 4. Volcar la imagen con el TOPLEVEL correcto
(format t "~%[BUILD] Generando binario industrial: ioe-dev...~%")

;; Importante: usamos uiop:symbol-call para asegurar que el paquete ya existe
(sb-ext:save-lisp-and-die "ioe-dev" 
                         :executable t 
                         :toplevel (find-symbol "RUN-SERVER" :cl-mcp-server))


