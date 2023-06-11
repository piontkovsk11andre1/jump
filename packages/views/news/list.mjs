export default ({server, queue, socket, postgres}) => {
    // Request of news list from database:
    server.get("/news/all", async (req, res) => {
        // Get list of news:
        const news = await postgres.query("SELECT id FROM news LIMIT 10")
        // Return as json:
        res.json(news)
    })

    // Setup update observer for this path:
    queue.on("news.create", ({data}) => {
        socket.to("/news/all").emit("refresh")
        socket.to(`/news/${data.id}`).emit("data", data)
    })
}