namespace APIdb.Models
{
    public class Signup
    {
        public string Nombre { get; set; }
        public int IdDocIdentidad { get; set; }
        public string ValorDocIdentidad { get; set; }
        public string FechaNacimiento { get; set; }
        public int IdPuesto { get; set; }
        public int IdDepartamento { get; set; }
        public int Activo { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int Tipo { get; set; }
    }
}
