import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { DataService } from '../data.service';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-articulos',
  templateUrl: './articulos.component.html',
  styleUrls: ['./articulos.component.css']
})
export class ArticulosComponent implements OnInit {
  usuario: string = "";
  clases: any[] = [];
  articulos: any[] = [];
  claseSeleccionada: any;
  mostrarCampoClase: boolean = false;
  cantidadArticulos: number = 0;
  nombreArticulo: string = "";
  mostrarParte: boolean = true;

  mostrarInsertar = false;
  mostrarActualizar = false;
  mostrarEliminar = false;

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
    private http: HttpClient
  ) {}

  ngOnInit() {
    // Realiza una solicitud HTTP GET a la API
    this.http.get<any>('http://localhost:5095/api/Articulos/GetArticulos')
      .subscribe(response => {
        this.articulos = response.Articles; // Asigna los datos de artículos a la propiedad "articulos"
        this.mostrarCampoClase = false
      });

      // Realiza una solicitud HTTP GET a la API para obtener las clases
      this.http.get<any>('http://localhost:5095/api/Clases/GetClases')
      .subscribe(response => {
        this.clases = response.Articles; // Asigna los datos de las clases a la propiedad "clases"
      // Asigna la primera clase como la seleccionada por defecto
      if (this.clases.length > 0) {
        this.claseSeleccionada = this.clases[0].id;
      }
      });
  }

  salir(){
    this.mostrarParte = false;
  }

  // Método para manejar el cambio en el select
  onClaseSeleccionadaChange(event: any) {
    this.claseSeleccionada = event.target.value;
  }

  // Método para filtrar por clase
  filtrarPorClase() {
    if (this.claseSeleccionada) {
      const idClaseSeleccionada = this.claseSeleccionada;

      this.http.post<any>('http://localhost:5095/api/FiltroClase/GetByClass', { IdClase: idClaseSeleccionada })
        .subscribe(response => {
          this.articulos = response.Articles; // Actualiza la lista de artículos con los resultados filtrados
          this.mostrarCampoClase = true;
        });
    } else {
      console.log('Selecciona una clase antes de aplicar el filtro.');
    }
  }

  // Método para manejar el cambio en el campo de cantidad
onCantidadArticulosChange() {
  // Preparar los datos para la solicitud
  const amountData = {
    cantidadN: this.cantidadArticulos
  };
   if (this.cantidadArticulos <= 0)
   {
    // Realiza una solicitud HTTP GET a la API
    this.http.get<any>('http://localhost:5095/api/Articulos/GetArticulos')
      .subscribe(response => {
        this.articulos = response.Articles; // Asigna los datos de artículos a la propiedad "articulos"
      });
   }else{
  // Realizar la solicitud HTTP
  this.http.post<any>('http://localhost:5095/api/FiltroCantidad/GetByAmount', amountData)
    .subscribe(response => {
      this.articulos = response.Articles; // Asigna los datos de los artículos
      this.mostrarCampoClase = false; // Muestra el campo "Clase" en la tabla
    });
    }
  }

  // Método para manejar el cambio en el campo de nombre del artículo
onNombreArticuloChange() {
  // Realiza una solicitud HTTP POST a la API para filtrar por nombre de artículo
  const nameData = {
    inStringCajaDeTexto: this.nombreArticulo
  };

  this.http.post<any>('http://localhost:5095/api/FiltroNombre/GetByName', nameData)
    .subscribe(response => {
      this.articulos = response.Articles; // Asigna los datos de los artículos
      this.mostrarCampoClase = true; // Oculta el campo "Clase" en la tabla
    });
  }
  // Método para enviar los datos al servidor
  insertarArticulo() {

    if (this.claseSeleccionada) {
      const idClaseSeleccionada = this.claseSeleccionada;
    // Realizar una solicitud HTTP POST para insertar el artículo
    this.http.post<any>('http://localhost:5095/api/Insertar/Insert', this.insertar)
      .subscribe(response => {
        // Manejar la respuesta del servidor, por ejemplo, mostrar un mensaje de éxito o error
        if (response.statusCode) {
          this.respuestaServidor = 'Artículo insertado exitosamente.';
          // Restablecer los valores de los campos de entrada
          this.insertar = {
          inIdClaseArticulo: 1,
          inCodigo: '',
          inNombre: '',
          inPrecio: 0.0
        };
          this.ngOnInit()
        } else {
          this.respuestaServidor = 'Error al insertar el artículo: ' + response.statusMessage;
        }
      });
    }
    this.respuestaServidor = "";
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

// Función para buscar un artículo por código
buscarArticuloPorCodigo() {
  if (this.codigoArticulo.trim() === '') {
    // Si el campo de código está vacío, no realizar la búsqueda
    this.articuloEncontrado = null;
    this.respuestaServidor = 'Ingresa un código de artículo válido.';
    return;
  }
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
}
