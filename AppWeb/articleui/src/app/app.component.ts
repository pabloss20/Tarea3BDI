import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  mostrarLogin: boolean = true;
  mostrarSignup: boolean = false;
  mostrarArticulos: boolean = false;


  mostrarSignupComponent() {
    this.mostrarLogin = false;
    this.mostrarSignup = true;
  }

  mostrarLoginComponent() {
    this.mostrarLogin = true;
    this.mostrarSignup = false;
  }

  mostrarArticulosComponent() {
    this.mostrarLogin = false;
    this.mostrarArticulos = true;
  }
}
