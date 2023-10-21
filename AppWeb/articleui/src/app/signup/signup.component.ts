import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent {
  nombre: string = "";
  idDocIdentidad: number = 1;
  valorDocIdentidad: string = "";
  fechaNacimiento: string = "";
  idPuesto: number = 1;
  idDepartamento: number = 1;
  activo: number = 1;
  username: string = "";
  password: string = "";
  tipo: number = 2;
  responseMessage: string = "";
  isRegistrationFormValid: boolean = false;

  @Output() showLoginEvent = new EventEmitter<void>();

  showLogin() {
    this.showLoginEvent.emit();
  }

  constructor(private http: HttpClient) {
    this.checkFormValidity();
  }

  onSubmit() {

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
          if (response.statusCode === true) {
            this.clearFormFields();
          }
        }, error => {
          console.error('Error en la solicitud HTTP:', error);
          this.responseMessage = 'Error al registrar el usuario.';
        });
  }

  checkFormValidity() {
    this.isRegistrationFormValid =
      this.nombre.trim() !== '' &&
      this.valorDocIdentidad.trim() !== '' &&
      this.fechaNacimiento.trim() !== '' &&
      this.username.trim() !== '' &&
      this.password.trim() !== '';
  }

  clearFormFields() {
    this.nombre = "";
    this.valorDocIdentidad = "";
    this.fechaNacimiento = "";
    this.username = "";
    this.password = "";
  }
}
