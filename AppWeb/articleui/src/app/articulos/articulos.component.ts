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
