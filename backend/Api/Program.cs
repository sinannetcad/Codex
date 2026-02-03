using Api.Models;
using Api.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<DatingService>();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

app.UseCors();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/api/health", () => Results.Ok(new { status = "ok" }));

app.MapPost("/api/auth/register", (RegisterRequest request, DatingService service) =>
{
    var response = service.Register(request);
    return Results.Ok(response);
});

app.MapPost("/api/auth/login", (LoginRequest request, DatingService service) =>
{
    var response = service.Login(request);
    return response is null ? Results.Unauthorized() : Results.Ok(response);
});

app.MapGet("/api/profiles", (Guid userId, DatingService service) =>
{
    var profiles = service.GetProfiles(userId);
    return Results.Ok(profiles);
});

app.MapPost("/api/swipes", (SwipeRequest request, DatingService service) =>
{
    var result = service.RegisterSwipe(request);
    return Results.Ok(result);
});

app.MapGet("/api/matches", (Guid userId, DatingService service) =>
{
    var matches = service.GetMatches(userId);
    return Results.Ok(matches);
});

app.Run();
