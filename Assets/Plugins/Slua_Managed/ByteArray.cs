

namespace SLua
{
    public class ByteArray
    {
        public byte[] data = null;
        public ByteArray()
        {
        }

        public ByteArray(byte[] d)
        {
            this.data = d;
        }

        public ByteArray(string d)
        {
            this.data = System.Text.Encoding.UTF8.GetBytes(d);
        }
    }
}

