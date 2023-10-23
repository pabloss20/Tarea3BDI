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
    public class FiltroNombreController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public FiltroNombreController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("GetByName")]
        public IActionResult FiltroNombre([FromBody] FiltroNombre filtroNombre)
        {
            try
            {
                DataTable empleadoTable = new DataTable();
                var clientIpAddress = HttpContext.Connection.RemoteIpAddress;
                var ip = clientIpAddress.ToString();

                using (SqlConnection connection = new SqlConnection(_configuration.GetConnectionString("connection")))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("SP_FiltroXNombreEmpleado", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@inIdUser", 5);
                        command.Parameters.AddWithValue("@inUsername", "perezjuan12");
                        command.Parameters.AddWithValue("@inPostIP", ip);
                        command.Parameters.AddWithValue("@inStringCajaDeTexto", filtroNombre.inStringCajaDeTexto);

                        SqlParameter retornoParameter = new SqlParameter("@outRetorno", SqlDbType.Bit);
                        retornoParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(retornoParameter);

                        SqlParameter messageParameter = new SqlParameter("@outMessage", SqlDbType.VarChar, 100);
                        messageParameter.Direction = ParameterDirection.Output;
                        command.Parameters.Add(messageParameter);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                        {
                            adapter.Fill(empleadoTable);
                        }

                        bool retorno = (bool)retornoParameter.Value;
                        string message = messageParameter.Value.ToString();

                        var response = new
                        {
                            statusCode = retorno,
                            statusMessage = message,
                            Articles = empleadoTable
                        };

                        return Ok(response);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al obtener empleados: " + ex.Message);
            }
        }
    }
}
