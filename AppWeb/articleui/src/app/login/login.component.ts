import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Output } from '@angular/core';
import {Router } from '@angular/router'

import { DataService } from '../data.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  username: string = "";
  password: string = "";
  showDialog = false;
  responseMessage: string = "";
  isFormValid: boolean = false;
  mostrarBoton: boolean = false;
  mostrarParte: boolean = true;

  @Output() showSignupEvent = new EventEmitter<void>();

  showSignup() {
    this.showSignupEvent.emit();
  }

  @Output() showArticulosEvent = new EventEmitter<void>();

  showArticulos() {
    console.log('articulos');
    this.showArticulosEvent.emit();
  }

  constructor(private http: HttpClient, private router: Router, private dataService: DataService) {
    // Llama a checkFormValidity al iniciar
    this.checkFormValidity();
  }

  onSubmit() {
    const loginData = {
      Username: this.username,
      Password: this.password,
    };

// Realiza la solicitud HTTP al servidor
this.http.post<any>('http://localhost:5095/api/Login/Login', loginData)
  .subscribe((response: any) => {
    this.responseMessage = response.statusMessage;
    this.showDialog = true;

    if (response.statusMessage === 'Usuario válido') {
      this.mostrarBoton = true;
      this.showDialog = false;
      this.mostrarParte = false;
      this.login();
    } else {
      this.mostrarBoton = false;
    }
  }, error => {
    console.error('Error en la solicitud HTTP:', error);
    this.responseMessage = 'Error al iniciar sesión.';
    this.showDialog = true;
  });

  }

  closeDialog() {
    this.showDialog = false;
  }

  checkFormValidity() {
    this.isFormValid = this.username.trim() !== '' && this.password.trim() !== '';
  }

  // Llama a checkFormValidity cada vez que cambie el valor de username o password
  onUsernameChange() {
    this.checkFormValidity();
  }

  onPasswordChange() {
    this.checkFormValidity();
  }

  login() {
    // Lógica de inicio de sesión
    const usuario = this.username
    this.dataService.usuario = usuario; // Establece el usuario en el servicio
  }
}
