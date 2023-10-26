using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Data;
using APIdb.Models;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EliminarController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public EliminarController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("BorrarEmpleadosMasivo")]
        public IActionResult BorrarEmpleadosMasivo([FromBody] Eliminar request)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    connection.Open();

                    SqlCommand command = new SqlCommand("BorrarEmpleadosMasivo", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Username", request.Username);
                    command.Parameters.AddWithValue("@IdsEmpleados", request.IdsEmpleados);

                    SqlParameter resultadoParam = new SqlParameter("@Resultado", SqlDbType.Int);
                    resultadoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(resultadoParam);

                    SqlParameter mensajeParam = new SqlParameter("@Mensaje", SqlDbType.NVarChar, -1);
                    mensajeParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(mensajeParam);

                    command.ExecuteNonQuery();

                    int resultado = (int)resultadoParam.Value;
                    string mensaje = mensajeParam.Value.ToString();

                    if (resultado == 1)
                    {
                        return Ok(new
                        {
                            Resultado = resultado,
                            Mensaje = mensaje
                        });
                    }
                    else
                    {
                        return BadRequest(new
                        {
                            Resultado = resultado,
                            Mensaje = mensaje
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al borrar empleados: " + ex.Message);
            }
        }
    } 
}

