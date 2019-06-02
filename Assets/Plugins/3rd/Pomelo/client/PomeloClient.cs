using SimpleJson;

using System;
using System.Net;
using System.Net.Sockets;
using UnityEngine;
#if UNITY_IPHONE
using System.Runtime.InteropServices;
#endif

namespace Pomelo.DotNetClient
{
    public class PomeloClient : IDisposable
    {
        public const string EVENT_DISCONNECT = "disconnect";

        private EventManager eventManager;
        private Socket socket;
        private Protocol protocol;
        private bool disposed = false;
        private uint reqId = 1;

        public PomeloClient(string host, int port)
        {
            this.eventManager = new EventManager();
			#if UNITY_IPHONE
				initIphoneClient(host, port);
			#else
				initClient(host, port);
			#endif
            

            this.protocol = new Protocol(this, socket);
        }
		#if UNITY_IPHONE
		[DllImport("__Internal")]
		private static extern string getIPv6(string mHost, string mPort);  

		//"192.168.1.1&&ipv4"
		public static string GetIPv6(string mHost, string mPort)
		{
			
			#if UNITY_IPHONE && !UNITY_EDITOR
			string mIPv6 = getIPv6(mHost, mPort);
			return mIPv6;
			#else
			return mHost + "&&ipv4";
			#endif
		}


		void getIPType(String serverIp, String serverPorts, out String newServerIp, out AddressFamily  mIPType)
		{
			
			mIPType = AddressFamily.InterNetwork;
			newServerIp = "";
			try
			{
				string mIPv6 = GetIPv6(serverIp, serverPorts);
				if (!string.IsNullOrEmpty(mIPv6))
				{
					string[] m_StrTemp = System.Text.RegularExpressions.Regex.Split(mIPv6, "&&");
					if (m_StrTemp != null && m_StrTemp.Length >= 2)
					{
						string IPType = m_StrTemp[1];
						if (IPType == "ipv6")
						{
							newServerIp = m_StrTemp[0];
							mIPType = AddressFamily.InterNetworkV6;
						}
					}
				}
			}
			catch (Exception e)
			{
				Debug.Log(String.Format("unable to connect to server: {0}", e.ToString()));
				return;
			}

		}

        private void initIphoneClient(string host, int port)
        {			
			Debug.Log ("serali ios platform host=" + host + ",port=" + port);
			IPAddress ipAddress;
			if (!IPAddress.TryParse(host, out ipAddress))
			{
				ipAddress = Dns.GetHostEntry(host).AddressList[0];
			}
			string serverIp = ipAddress.ToString();
			string serverPorts = port.ToString();
			String newServerIp = "";
			AddressFamily newAddressFamily = AddressFamily.InterNetwork;
			getIPType(host, serverPorts, out newServerIp, out newAddressFamily);

			Debug.Log("serali serverIP:" + serverIp);
			Debug.Log ("serali serverPorts:" + serverPorts);
			Debug.Log ("serali newServerIp:" + newServerIp);
			Debug.Log ("serali newAddressFamily.ToString():" + newAddressFamily.ToString());
			if (!string.IsNullOrEmpty(newServerIp))
			{ 
				serverIp = newServerIp;
			}

			this.socket = new Socket(newAddressFamily, SocketType.Stream, ProtocolType.Tcp);
			IPAddress newipAddress = IPAddress.Parse (serverIp);
			IPEndPoint ie = new IPEndPoint (newipAddress,port);

			try
			{
				Debug.Log ("serali newipAddress = " + newipAddress + "....." +  "port = " + port);
				this.socket.Connect(ie);
			}
			catch (SocketException e)
			{
				Debug.Log ("serali error...............");
				Console.WriteLine(String.Format("unable to connect to server: {0}", e.ToString()));
				return;
			}
        }

		#endif

		private void initClient(string host, int port)
		{
			Debug.Log ("serali android platform host=" + host + ",port=" + port);
			IPAddress ipAddress;
			if (!IPAddress.TryParse(host, out ipAddress))
			{
				ipAddress = Dns.GetHostEntry(host).AddressList[0];
			}
			this.socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
			IPEndPoint ie = new IPEndPoint(ipAddress, port);
			try
			{
				this.socket.Connect(ie);
			}
			catch (SocketException e)
			{
				Console.WriteLine(String.Format("unable to connect to server: {0}", e.ToString()));
				return;
			}
		}

        public void connect()
        {
            protocol.start(null, null);
        }

        public void connect(JsonObject user)
        {
            protocol.start(user, null);
        }

        public void connect(Action<JsonObject> handshakeCallback)
        {
            protocol.start(null, handshakeCallback);
        }

        public bool connect(JsonObject user, Action<JsonObject> handshakeCallback)
        {
            try
            {
                protocol.start(user, handshakeCallback);
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
                return false;
            }
        }

        public void request(string route, Action<JsonObject> action)
        {
            this.request(route, new JsonObject(), action);
        }

        public void request(string route, JsonObject msg, Action<JsonObject> action)
        {
            try
            {
                var req_id = reqId++;
                this.eventManager.AddCallBack(req_id, action);
                protocol.send(route, req_id, msg);//发送失败导致reqId不增加。下次再访问会出错。

                //reqId++;
            }
            catch (Exception e)
            {
                Debug.LogWarning("connect error!");
                //throw new Exception("connect error!");
            }
        }

        public void notify(string route, JsonObject msg)
        {
            protocol.send(route, msg);
        }

        public void on(string eventName, Action<JsonObject> action)
        {
            eventManager.AddOnEvent(eventName, action);
        }

        internal void processMessage(Message msg)
        {
            if (msg.type == MessageType.MSG_RESPONSE)
            {
                eventManager.InvokeCallBack(msg.id, msg.data);
            }
            else if (msg.type == MessageType.MSG_PUSH)
            {
                eventManager.InvokeOnEvent(msg.route, msg.data);
            }
        }

        public void disconnect()
        {
            Dispose();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        // The bulk of the clean-up code 
        protected virtual void Dispose(bool disposing)
        {
            if (this.disposed) return;

            if (disposing)
            {
                // free managed resources
                this.protocol.close();
                try
                {
                    this.socket.Shutdown(SocketShutdown.Both);
                    this.socket.Close();
                }
                catch (Exception e)
                {
                    //bug fixed
                    //被动断线的情况下，socket已经被关闭，会抛出错误，以致 EVENT_DISCONNECT 没有成功回调
                }
                this.disposed = true;

                //Call disconnect callback
                eventManager.InvokeOnEvent(EVENT_DISCONNECT, null);
            }
        }
    }
}

