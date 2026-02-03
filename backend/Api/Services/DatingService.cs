using Api.Models;

namespace Api.Services;

public class DatingService
{
    private readonly object _lock = new();
    private readonly Dictionary<Guid, UserProfile> _profiles = new();
    private readonly Dictionary<string, Guid> _emailIndex = new(StringComparer.OrdinalIgnoreCase);
    private readonly List<(Guid From, Guid To, bool Liked)> _swipes = new();
    private readonly List<Match> _matches = new();

    public DatingService()
    {
        SeedProfiles();
    }

    public AuthResponse Register(RegisterRequest request)
    {
        lock (_lock)
        {
            if (_emailIndex.ContainsKey(request.Email))
            {
                var existingId = _emailIndex[request.Email];
                return new AuthResponse(existingId, CreateToken(existingId), _profiles[existingId]);
            }

            var profile = new UserProfile(
                Guid.NewGuid(),
                request.Name,
                request.Age,
                request.Bio,
                request.AvatarUrl,
                "Istanbul",
                new List<string> { "Coffee", "Travel", "Music" }
            );

            _profiles[profile.Id] = profile;
            _emailIndex[request.Email] = profile.Id;

            return new AuthResponse(profile.Id, CreateToken(profile.Id), profile);
        }
    }

    public AuthResponse? Login(LoginRequest request)
    {
        lock (_lock)
        {
            if (!_emailIndex.TryGetValue(request.Email, out var userId))
            {
                return null;
            }

            return new AuthResponse(userId, CreateToken(userId), _profiles[userId]);
        }
    }

    public IReadOnlyList<UserProfile> GetProfiles(Guid userId)
    {
        lock (_lock)
        {
            return _profiles.Values.Where(profile => profile.Id != userId).ToList();
        }
    }

    public SwipeResult RegisterSwipe(SwipeRequest request)
    {
        lock (_lock)
        {
            _swipes.RemoveAll(entry => entry.From == request.FromUserId && entry.To == request.ToUserId);
            _swipes.Add((request.FromUserId, request.ToUserId, request.Liked));

            if (!request.Liked)
            {
                return new SwipeResult(false, null);
            }

            var reciprocal = _swipes.Any(entry =>
                entry.From == request.ToUserId && entry.To == request.FromUserId && entry.Liked);

            if (!reciprocal)
            {
                return new SwipeResult(false, null);
            }

            if (!_profiles.TryGetValue(request.FromUserId, out var currentProfile) ||
                !_profiles.TryGetValue(request.ToUserId, out var otherProfile))
            {
                return new SwipeResult(false, null);
            }

            var match = new Match(Guid.NewGuid(), currentProfile, otherProfile, DateTimeOffset.UtcNow);
            _matches.Add(match);

            return new SwipeResult(true, otherProfile);
        }
    }

    public IReadOnlyList<Match> GetMatches(Guid userId)
    {
        lock (_lock)
        {
            return _matches
                .Where(match => match.User.Id == userId || match.MatchedWith.Id == userId)
                .ToList();
        }
    }

    private void SeedProfiles()
    {
        var profiles = new List<UserProfile>
        {
            new(Guid.NewGuid(), "Elif", 27, "Kahve tutkunu, sahil yürüyüşlerini severim.", "https://picsum.photos/seed/elif/300", "Izmir", new List<string> { "Coffee", "Sea", "Photography" }),
            new(Guid.NewGuid(), "Mert", 30, "Hafta sonu gezginiyim.", "https://picsum.photos/seed/mert/300", "Ankara", new List<string> { "Travel", "Food", "Movies" }),
            new(Guid.NewGuid(), "Zeynep", 25, "Konser avcısı.", "https://picsum.photos/seed/zeynep/300", "Istanbul", new List<string> { "Music", "Art", "Dance" })
        };

        foreach (var profile in profiles)
        {
            _profiles[profile.Id] = profile;
        }
    }

    private static string CreateToken(Guid userId) => $"demo-token-{userId}";
}
