using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using APIdb.Models;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlanillaMensualController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PlanillaMensualController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("ObtenerPlanillaMensual")]
        public IActionResult ObtenerPlanillaMensual([FromBody] PlanillaMensual planillaMensual)
        {
            try
            {
                string sqlDatasource = _configuration.GetConnectionString("connection");

                using (SqlConnection connection = new SqlConnection(sqlDatasource))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("ObtenerPlanillaMensual", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@inIdUser", planillaMensual.IdUser);
                        command.Parameters.AddWithValue("@inUsername", planillaMensual.Username);
                        command.Parameters.AddWithValue("@inPostIP", planillaMensual.PostIP);
                        command.Parameters.AddWithValue("@EmpleadoId", planillaMensual.EmpleadoId);
                        command.Parameters.AddWithValue("@MesInicio", planillaMensual.MesInicio);

                        SqlParameter salarioBrutoMensualParameter = new SqlParameter("@outSalarioBrutoMensual", SqlDbType.Decimal);
                        salarioBrutoMensualParameter.Direction = ParameterDirection.Output;
                        salarioBrutoMensualParameter.Precision = 10;
                        salarioBrutoMensualParameter.Scale = 2;
                        command.Parameters.Add(salarioBrutoMensualParameter);

                        SqlParameter totalDeduccionesMensualesParameter = new SqlParameter("@outTotalDeduccionesMensuales", SqlDbType.Decimal);
                        totalDeduccionesMensualesParameter.Direction = ParameterDirection.Output;
                        totalDeduccionesMensualesParameter.Precision = 10;
                        totalDeduccionesMensualesParameter.Scale = 2;
                        command.Parameters.Add(totalDeduccionesMensualesParameter);

                        SqlParameter retornoParameter = new SqlParameter("@outRetorno", SqlDbType.Bit);
                        retornoParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(retornoParameter);

                        SqlParameter messageParameter = new SqlParameter("@outMensaje", SqlDbType.VarChar, 100);
                        messageParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(messageParameter);

                        command.ExecuteNonQuery();

                        decimal salarioBrutoMensual = salarioBrutoMensualParameter.Value != DBNull.Value ? (decimal)salarioBrutoMensualParameter.Value : 0;
                        decimal totalDeduccionesMensuales = totalDeduccionesMensualesParameter.Value != DBNull.Value ? (decimal)totalDeduccionesMensualesParameter.Value : 0;
                        bool retorno = (bool)retornoParameter.Value;
                        string message = messageParameter.Value.ToString();

                        var response = new
                        {
                            StatusCode = retorno,
                            StatusMessage = message,
                            SalarioBrutoMensual = salarioBrutoMensual,
                            TotalDeduccionesMensuales = totalDeduccionesMensuales
                        };

                        return Ok(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al obtener planilla mensual: " + ex.Message);
            }
        }
    }
}
