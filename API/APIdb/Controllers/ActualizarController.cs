using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmpleadoController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public EmpleadoController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPut("EditarEmpleado")]
        public IActionResult EditarEmpleado([FromBody] Empleado empleado)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection")))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("EditarEmpleado", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Parámetros de entrada
                        command.Parameters.Add(new SqlParameter("@Id", SqlDbType.Int)).Value = empleado.Id;
                        command.Parameters.Add(new SqlParameter("@Nombre", SqlDbType.VarChar, 255)).Value = empleado.Nombre;
                        command.Parameters.Add(new SqlParameter("@TipoDocIdentidadId", SqlDbType.Int)).Value = empleado.TipoDocIdentidadId;
                        command.Parameters.Add(new SqlParameter("@ValorDocIdentidad", SqlDbType.VarChar, 50)).Value = empleado.ValorDocIdentidad;
                        command.Parameters.Add(new SqlParameter("@FechaNacimiento", SqlDbType.Date)).Value = empleado.FechaNacimiento;
                        command.Parameters.Add(new SqlParameter("@PuestoId", SqlDbType.Int)).Value = empleado.PuestoId;
                        command.Parameters.Add(new SqlParameter("@DepartamentoId", SqlDbType.Int)).Value = empleado.DepartamentoId;

                        // Parámetros de salida
                        command.Parameters.Add(new SqlParameter("@Resultado", SqlDbType.Bit)).Direction = ParameterDirection.Output;
                        command.Parameters.Add(new SqlParameter("@Mensaje", SqlDbType.VarChar, -1)).Direction = ParameterDirection.Output;

                        command.ExecuteNonQuery();

                        bool resultado = (bool)command.Parameters["@Resultado"].Value;
                        string mensaje = command.Parameters["@Mensaje"].Value.ToString();

                        if (resultado)
                        {
                            return Ok(new { Mensaje = mensaje });
                        }
                        else
                        {
                            return BadRequest(new { Mensaje = mensaje });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Error = ex.Message });
            }
        }
    }
}
