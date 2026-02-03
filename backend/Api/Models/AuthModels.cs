namespace Api.Models;

public record RegisterRequest(string Name, int Age, string Bio, string AvatarUrl, string Email, string Password);

public record LoginRequest(string Email, string Password);

public record AuthResponse(Guid UserId, string Token, UserProfile Profile);
