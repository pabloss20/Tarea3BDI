namespace APIdb.Models
{
    public class Actualizar
    {
        public string Username { get; set; }
        public int IdClaseArticulo { get; set; }
        public int AnteriorIdClase { get; set; }
        public int IdArticulo { get; set; }
        public string CodigoNuevo { get; set; }
        public string CodigoAnterior { get; set; }
        public string NombreNuevo { get; set; }
        public string NombreAnterior { get; set; }

        public float Precio { get; set; }
    }
}
