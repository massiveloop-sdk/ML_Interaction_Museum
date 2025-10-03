#if UNITY_EDITOR
namespace TextureTools
{
    public class TextureChannelSettings
    {
        public TextureChannel red;

        public TextureChannel green;

        public TextureChannel blue;

        public TextureChannel alpha;

        public TextureChannelSettings()
        {
            red = new TextureChannel()
            {
                channel = 0,
                invert = false
            };

            green = new TextureChannel()
            {
                channel = 1,
                invert = false
            };

            blue = new TextureChannel()
            {
                channel = 2,
                invert = false
            };

            alpha = new TextureChannel()
            {
                channel = 3,
                invert = false
            };
        }
    }
}
#endif