using APIdb.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;

namespace APIdb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public LoginController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("Login")]
        public IActionResult Login([FromBody] Login login)
        {
            try
            {
                var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
                var ip = clientIpAddress.ToString();

                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    connection.Open();

                    SqlCommand command = new SqlCommand("ValidarEmpleado", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Username", login.Username);
                    command.Parameters.AddWithValue("@Password", login.Password);

                    // Configura los parámetros de salida
                    SqlParameter resultadoParam = new SqlParameter("@Resultado", SqlDbType.Bit);
                    resultadoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(resultadoParam);

                    SqlParameter mensajeParam = new SqlParameter("@Mensaje", SqlDbType.VarChar, -1);
                    mensajeParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(mensajeParam);

                    SqlParameter tipoParam = new SqlParameter("@Tipo", SqlDbType.Int);
                    tipoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(tipoParam);

                    SqlParameter tipoIdEmpleadoParam = new SqlParameter("@TipoIdEmpleado", SqlDbType.Int);
                    tipoIdEmpleadoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(tipoIdEmpleadoParam);

                    command.ExecuteNonQuery();

                    bool resultado = (bool)resultadoParam.Value;
                    string mensaje = mensajeParam.Value.ToString();
                    int tipo = (int)tipoParam.Value;
                    int tipoIdEmpleado = (int)tipoIdEmpleadoParam.Value;

                    if (resultado)
                    {
                        return Ok(new
                        {
                            Resultado = resultado,
                            Mensaje = mensaje,
                            Tipo = tipo,
                            TipoIdEmpleado = tipoIdEmpleado
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
                return StatusCode(500, "Error al autenticar: " + ex.Message);
            }
        }
    }
}
