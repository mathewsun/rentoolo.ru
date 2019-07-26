namespace Rentoolo.Model
{
    public class FavoritesForPage
    {
        public long Id { get; set; }

        public long AdvertId { get; set; }

        public System.DateTime Created { get; set; }

        public int? Category { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public System.DateTime CreatedAdvert { get; set; }

        public long CreatedUserId { get; set; }

        public float Price { get; set; }

        public string Address { get; set; }

        public string Phone { get; set; }

        public string MessageType { get; set; }

        public string Position { get; set; }

        public System.DateTime CreatedFavorites { get; set; }
    }
}