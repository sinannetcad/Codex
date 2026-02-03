namespace Api.Models;

public record UserProfile(Guid Id, string Name, int Age, string Bio, string AvatarUrl, string City, IReadOnlyList<string> Interests);

public record SwipeRequest(Guid FromUserId, Guid ToUserId, bool Liked);

public record SwipeResult(bool IsMatch, UserProfile? MatchedProfile);

public record Match(Guid MatchId, UserProfile User, UserProfile MatchedWith, DateTimeOffset MatchedAt);
