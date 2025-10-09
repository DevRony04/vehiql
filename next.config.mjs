/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
   experimental: {
    serverComponentsHmrCache: false, // defaults to true
  },

    images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "mlbmgvlpbnkzsvcuxhyb.supabase.co",
      },
    ],
  },

  async headers() {
    return [
      {
        source: "/embed",
        headers: [
          {
            key: "Content-Security-Policy",
            value: "frame-src 'self'https://rony.created.app;",
          },
        ],
      },
    ];
  },
};

export default nextConfig;