import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { DataService } from '../data.service';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { FiltroNombreService } from '../filtro-nombre.service';

@Component({
  selector: 'app-articulos',
  templateUrl: './articulos.component.html',
  styleUrls: ['./articulos.component.css']
})
export class ArticulosComponent implements OnInit {

  private baseUrl = 'http://localhost:5095/api/FiltroNombre'; // Reemplaza con la URL correcta de tu API

  usuario: string = "";
  clases: any[] = [];
  articulos: any[] = [];
  claseSeleccionada: any;
  mostrarCampoClase: boolean = false;
  cantidadArticulos: number = 0;
  nombreArticulo: string = "";
  mostrarParte: boolean = true;

  // Parte de actualizar
  nombreEmpleado: string = "";
  tipoDocIdentidadId: number = 0;
  valorDocIdentidad: string = "";
  fechaNacimiento: string = "";
  puestoId: number = 0;
  departamentoId: number = 0;


  Empleados: any[] = [];
  empleadoSeleccionado: any = null;
  impersonarHabilitado: boolean = false;
  actualizarHabilitado: boolean = false;
  eliminarHabilitado: boolean = false;


  mostrarInsertar = false;
  mostrarActualizar = false;
  mostrarEliminar = false;

  mostrarComponenteEmp = true; // Componente 1 visible por defecto
  mostrarComponenteDel = false; // Componente 2 oculto por defecto
  mostrarComponenteUpd = false; // Componente 2 oculto por defecto


    // Objeto para almacenar los datos del formulario
    insertar = {
      inIdClaseArticulo: 1,
      inCodigo: '',
      inNombre: '',
      inPrecio: 0.0
    };
    respuestaServidor: string = "";

    codigoArticulo: string = '';
  articuloEncontrado: any = null;

  constructor(
    private route: ActivatedRoute,
    public dataService: DataService,
    private http: HttpClient,
    private filtroNombreService: FiltroNombreService,
  ) {}

  ngOnInit() {
    this.http.post<any>('http://localhost:5095/GetEmpleados', {}).subscribe(
      data => {
        this.Empleados = data.Empleados;
      },
      error => {
        console.error('Error en la solicitud HTTP:', error);
      }
    );

    console.log(this.Empleados.length)
  }

  salir(){
    this.mostrarParte = false;
  }

  // Método para manejar el cambio en el select
  onClaseSeleccionadaChange(event: any) {
    this.claseSeleccionada = event.target.value;
  }

  limpiar()
  {
    // Restablecer los valores de los campos de entrada
    this.insertar = {
      inIdClaseArticulo: 1,
      inCodigo: '',
      inNombre: '',
      inPrecio: 0.0
    };
  }

  // En tu archivo articulos.component.ts
camposLlenos(): boolean {
  return (
    this.insertar.inCodigo.trim() !== '' &&
    this.insertar.inNombre.trim() !== '' &&
    this.insertar.inPrecio > 0
  );
}

mostrarInsertarBoton = true;
// Otras propiedades y métodos de tu componente...

isFormValid(): boolean {
  return (
    !!this.insertar.inCodigo && // Verifica que el campo "Código" no esté vacío
    !!this.insertar.inNombre && // Verifica que el campo "Nombre" no esté vacío
    typeof this.insertar.inPrecio === 'number' // Verifica que el campo "Precio" sea un número
  );
}
refrescar(){this.ngOnInit()}

  // Método para manejar la selección de un empleado
  seleccionarEmpleado(empleado: any) {
    if (this.empleadoSeleccionado === empleado) {
      // Si se vuelve a hacer clic en el mismo empleado, deshabilita el impersonar
      this.empleadoSeleccionado = null;
      this.impersonarHabilitado = false;
      this.actualizarHabilitado = false;
      this.eliminarHabilitado = false;
    } else {
      // Si se hace clic en un nuevo empleado, habilita el impersonar
      this.empleadoSeleccionado = empleado;
      this.impersonarHabilitado = true;
      this.actualizarHabilitado = true;
      this.eliminarHabilitado = true;
    }
  }
  filtrarPorNombre() {
    if (this.nombreArticulo.trim() !== '') {
      const filtro = { inStringCajaDeTexto: this.nombreArticulo };
      this.http.post('http://localhost:5095/api/FiltroNombre/GetByName', filtro)
        .subscribe((data: any) => {
          this.Empleados = data.Articles;
        });
    }
  }

    // Método para mostrar Componente 1
    mostrarComponente1() {
      this.mostrarComponenteEmp = true;
      this.mostrarComponenteDel = false;
      this.mostrarComponenteUpd = false;
    }

    // Método para mostrar Componente 2
    mostrarComponente2() {
      this.mostrarComponenteEmp = false;
      this.mostrarComponenteDel = true;
      this.mostrarComponenteUpd = false;
    }
    // Método para mostrar Componente 2
    mostrarComponente3() {
      this.mostrarComponenteEmp = false;
      this.mostrarComponenteDel = false;
      this.mostrarComponenteUpd = true;
        }


  guardarEmpleado(){}
}
