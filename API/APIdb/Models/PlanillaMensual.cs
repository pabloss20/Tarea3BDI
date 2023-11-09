using System;

namespace APIdb.Models
{
    public class PlanillaMensual
    {
        public int IdUser { get; set; }
        public string Username { get; set; }
        public string PostIP { get; set; }
        public int EmpleadoId { get; set; }
        public DateTime MesInicio { get; set; }
        public decimal SalarioBrutoMensual { get; set; }
        public decimal TotalDeduccionesMensuales { get; set; }
        public bool Retorno { get; set; }
        public string Mensaje { get; set; }
    }
}
