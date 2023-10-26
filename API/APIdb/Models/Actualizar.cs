namespace APIdb.Models
{
    public class Empleado
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public int TipoDocIdentidadId { get; set; }
        public string ValorDocIdentidad { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public int PuestoId { get; set; }
        public int DepartamentoId { get; set; }
    }
}
