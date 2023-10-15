import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Output } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.css']
})
export class SignupComponent {
  username: string = "";
  password: string = "";
  responseMessage: string = "";
  isRegistrationFormValid: boolean = false;

  @Output() showLoginEvent = new EventEmitter<void>();

  showLogin() {
    this.showLoginEvent.emit();
  }

  constructor(private http: HttpClient, private router: RouterModule) {
    // Llama a checkFormValidity al iniciar
    this.checkFormValidity();
  }

  onSubmit() {
    const signupData = {
      UserName: this.username,
      Password: this.password
    };

    this.http.post<any>('http://localhost:5095/api/Signup/Signup', signupData)
      .subscribe((response: any) => {
        this.responseMessage = response.statusMessage;
      }, error => {
        console.error('Error en la solicitud HTTP:', error);
        this.responseMessage = 'Error al registrar el usuario.';
      });
  }

  checkFormValidity() {
    this.isRegistrationFormValid = this.username.trim() !== '' && this.password.trim() !== '';
  }

  // Llama a checkFormValidity cada vez que cambie el valor de username o password
  onUsernameChange() {
    this.checkFormValidity();
  }

  onPasswordChange() {
    this.checkFormValidity();
  }
}
