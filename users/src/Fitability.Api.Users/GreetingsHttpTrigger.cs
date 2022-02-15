using System.IO;
using System.Net;
using System.Threading.Tasks;

using Fitability.Api.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;

using Newtonsoft.Json;

namespace Fitability.Api.Users
{
    public class GreetingsHttpTrigger
    {
        private readonly ILogger<GreetingsHttpTrigger> _logger;

        public GreetingsHttpTrigger(ILogger<GreetingsHttpTrigger> log)
        {
            _logger = log;
        }

        [FunctionName(nameof(GreetingsHttpTrigger.Greetings))]
        [OpenApiOperation(operationId: "greetings", tags: new[] { "greetings" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(GreetingResponse), Description = "The OK response")]
        public async Task<IActionResult> Greetings(
            [HttpTrigger(AuthorizationLevel.Function, "GET", Route = "greetings")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            string responseMessage = string.IsNullOrEmpty(name)
                ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
                : $"Hello, {name}. This HTTP triggered function executed successfully.";

            var res = new GreetingResponse() { Message = responseMessage };

            return new OkObjectResult(res);
        }
    }
}