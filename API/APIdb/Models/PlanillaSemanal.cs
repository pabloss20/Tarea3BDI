namespace APIdb.Models
{
    public class UltimasPlanillas
    {
        public int IdUser { get; set; }
        public string Username { get; set; }
        public string PostIP { get; set; }
        public int EmpleadoId { get; set; }
        public int CantidadPlanillas { get; set; }
        public bool Retorno { get; set; }
        public string Mensaje { get; set; }
        public List<PlanillaSemanal> Planillas { get; set; }
    }

    public class PlanillaSemanal
    {
        public int Id { get; set; }
        public DateTime SemanaInicio { get; set; }
        public decimal SalarioBruto { get; set; }
        public decimal TotalDeducciones { get; set; }
        public decimal SalarioNeto { get; set; }
    }
}
