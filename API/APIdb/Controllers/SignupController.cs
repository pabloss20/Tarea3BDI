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
    public class SignupController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public SignupController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("Signup")]
        public IActionResult Signup([FromBody] Signup signup)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    connection.Open();

                    SqlCommand command = new SqlCommand("RegistrarEmpleado", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Nombre", signup.Nombre);
                    command.Parameters.AddWithValue("@IdDocIdentidad", signup.IdDocIdentidad);
                    command.Parameters.AddWithValue("@ValorDocIdentidad", signup.ValorDocIdentidad);
                    command.Parameters.AddWithValue("@FechaNacimiento", signup.FechaNacimiento);
                    command.Parameters.AddWithValue("@IdPuesto", signup.IdPuesto);
                    command.Parameters.AddWithValue("@IdDepartamento", signup.IdDepartamento);
                    command.Parameters.AddWithValue("@Activo", signup.Activo);
                    command.Parameters.AddWithValue("@Username", signup.Username);
                    command.Parameters.AddWithValue("@Password", signup.Password);
                    command.Parameters.AddWithValue("@Tipo", signup.Tipo);

                    SqlParameter registradoParam = new SqlParameter("@Registrado", SqlDbType.Bit);
                    registradoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(registradoParam);

                    SqlParameter messageParam = new SqlParameter("@Message", SqlDbType.VarChar, 100);
                    messageParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(messageParam);

                    command.ExecuteNonQuery();

                    bool registrado = (bool)registradoParam.Value;
                    string message = messageParam.Value.ToString();

                    if (registrado)
                    {
                        return Ok(new
                        {
                            StatusCode = registrado,
                            StatusMessage = message,
                        });
                    }
                    else
                    {
                        return BadRequest(new
                        {
                            StatusCode = registrado,
                            StatusMessage = message
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al registrar el empleado: " + ex.Message);
            }
        }
    }
}
