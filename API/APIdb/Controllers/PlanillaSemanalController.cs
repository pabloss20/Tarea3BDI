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
    public class PlanillasController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PlanillasController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("ObtenerUltimasPlanillas")]
        public IActionResult ObtenerUltimasPlanillas([FromBody] UltimasPlanillas ultimasPlanillas)
        {
            try
            {
                string sqlDatasource = _configuration.GetConnectionString("connection");
                DataTable planillasTable = new DataTable();

                using (SqlConnection connection = new SqlConnection(sqlDatasource))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("ObtenerUltimasPlanillas", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@inIdUser", ultimasPlanillas.IdUser);
                        command.Parameters.AddWithValue("@inUsername", ultimasPlanillas.Username);
                        command.Parameters.AddWithValue("@inPostIP", ultimasPlanillas.PostIP);
                        command.Parameters.AddWithValue("@EmpleadoId", ultimasPlanillas.EmpleadoId);
                        command.Parameters.AddWithValue("@CantidadPlanillas", ultimasPlanillas.CantidadPlanillas);

                        SqlParameter retornoParameter = new SqlParameter("@outRetorno", SqlDbType.Bit);
                        retornoParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(retornoParameter);

                        SqlParameter messageParameter = new SqlParameter("@outMensaje", SqlDbType.VarChar, 100);
                        messageParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(messageParameter);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            adapter.Fill(planillasTable);
                        }

                        bool retorno = (bool)retornoParameter.Value;
                        string message = messageParameter.Value.ToString();

                        List<PlanillaSemanal> planillas = new List<PlanillaSemanal>();
                        foreach (DataRow row in planillasTable.Rows)
                        {
                            planillas.Add(new PlanillaSemanal
                            {
                                Id = Convert.ToInt32(row["Id"]),
                                SemanaInicio = Convert.ToDateTime(row["SemanaInicio"]),
                                SalarioBruto = Convert.ToDecimal(row["SalarioBruto"]),
                                TotalDeducciones = Convert.ToDecimal(row["TotalDeducciones"]),
                                SalarioNeto = Convert.ToDecimal(row["SalarioNeto"])
                            });
                        }

                        var response = new
                        {
                            StatusCode = retorno,
                            StatusMessage = message,
                            Planillas = planillas
                        };

                        return Ok(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al obtener planillas: " + ex.Message);
            }
        }
    }
}
