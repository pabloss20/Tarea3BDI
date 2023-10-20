import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent {
  // Declarar propiedades para los nuevos campos del formulario
  nombre: string = "";
  idDocIdentidad: number = 1;
  valorDocIdentidad: string = "";
  fechaNacimiento: string = "";
  idPuesto: number = 1;
  idDepartamento: number = 1;
  activo: number = 1;
  username: string = "";
  password: string = "";
  tipo: number = 2; // 2 para empleado por defecto
  responseMessage: string = "";
  isRegistrationFormValid: boolean = false;

  @Output() showLoginEvent = new EventEmitter<void>();

  showLogin() {
    this.showLoginEvent.emit();
  }

  constructor(private http: HttpClient) {
    // Llama a checkFormValidity al iniciar
    this.checkFormValidity();
  }

  registrarEmpleado() {
    // Validar que los campos requeridos no estén vacíos
    if (this.isRegistrationFormValid) {
      const signupData = {
        nombre: this.nombre,
        idDocIdentidad: this.idDocIdentidad,
        valorDocIdentidad: this.valorDocIdentidad,
        fechaNacimiento: this.fechaNacimiento,
        idPuesto: this.idPuesto,
        idDepartamento: this.idDepartamento,
        activo: this.activo,
        username: this.username,
        password: this.password,
        tipo: this.tipo,
      };

      this.http.post<any>('http://localhost:5095/api/Signup/Signup', signupData)
        .subscribe((response: any) => {
          this.responseMessage = response.statusMessage;
        }, error => {
          console.error('Error en la solicitud HTTP:', error);
          this.responseMessage = 'Error al registrar el usuario.';
        });
    } else {
      this.responseMessage = 'Por favor, complete todos los campos requeridos.';
    }
  }

  checkFormValidity() {
    // Verifica que los campos requeridos estén completos
    this.isRegistrationFormValid =
      this.nombre.trim() !== '' &&
      this.valorDocIdentidad.trim() !== '' &&
      this.fechaNacimiento.trim() !== '' &&
      this.username.trim() !== '' &&
      this.password.trim() !== '';
  }

  // Llama a checkFormValidity cada vez que cambie el valor de los campos requeridos
  onNombreChange() {
    this.checkFormValidity();
  }

  onValorDocIdentidadChange() {
    this.checkFormValidity();
  }

  onFechaNacimientoChange() {
    this.checkFormValidity();
  }

  onUsernameChange() {
    this.checkFormValidity();
  }

  onPasswordChange() {
    this.checkFormValidity();
  }
}
