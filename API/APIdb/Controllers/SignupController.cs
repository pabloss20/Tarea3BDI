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

        // POST el cual se usa para registrar un nuevo usuario
        [HttpPost]
        [Route("Signup")]
        public IActionResult Signup([FromBody] Signup signup)
        {
            try
            {
                // Conexión en appsettings.json
                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection").ToString()))
                {
                    // Inicia la conexión
                    connection.Open();
                    // Se llama al SP (nombre de SP, conexión)
                    SqlCommand command = new SqlCommand("RegistrarEmpleado", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    // Parámetros de entrada (BD, Modelo)
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

                    // Parámetros de salida
                    SqlParameter registradoParam = new SqlParameter("@Registrado", SqlDbType.Bit);
                    registradoParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(registradoParam);

                    SqlParameter messageParam = new SqlParameter("@Message", SqlDbType.VarChar, 100);
                    messageParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(messageParam);

                    // Nuevo parámetro de salida para el tipo de usuario
                    SqlParameter tipoUsuarioOutputParam = new SqlParameter("@TipoUsuarioOutput", SqlDbType.Int);
                    tipoUsuarioOutputParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(tipoUsuarioOutputParam);

                    // Ejecuta el procedimiento almacenado
                    command.ExecuteNonQuery();

                    // Obtiene los valores de los parámetros de salida
                    bool registrado = (bool)registradoParam.Value;
                    string message = messageParam.Value.ToString();
                    int tipoUsuarioOutput = (int)tipoUsuarioOutputParam.Value;

                    // Instancia de tu modelo de respuesta
                    var response = new 
                    {
                        StatusCode = registrado,
                        StatusMessage = message,
                        TipoUsuario = tipoUsuarioOutput
                    };

                    return Ok(response);
                }
            }
            catch (Exception ex)
            {
                // Manejo de errores
                return StatusCode(500, "Error al registrar el empleado: " + ex.Message);
            }
        }
    }
}
