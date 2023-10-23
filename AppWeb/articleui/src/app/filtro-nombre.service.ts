// filtro-nombre.service.ts

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class FiltroNombreService {
  private baseUrl = 'http://localhost:5095/api/FiltroNombre'; // Reemplaza con la URL correcta de tu API

  constructor(private http: HttpClient) {}

  getEmpleadosByNombre(nombre: string): Observable<any> {
    return this.http.post<any>(`${this.baseUrl}/GetByName`, { inStringCajaDeTexto: nombre });
  }
}
