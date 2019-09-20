using System;

namespace Rentoolo.Model
{
    public class FavoritesForPage
    {
        public long Id { get; set; }

        public long AdvertId { get; set; }

        public System.DateTime CreatedAdverts { get; set; }

        public int? Category { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public System.DateTime CreatedFavorites { get; set; }

        public Guid CreatedUserId { get; set; }

        public double Price { get; set; }

        public string Address { get; set; }

        public string Phone { get; set; }

        /// <summary>
        /// Способ связи
        /// </summary>
        public int MessageType { get; set; }

        public string Position { get; set; }

        public string ImgUrls { get; set; }
    }
}