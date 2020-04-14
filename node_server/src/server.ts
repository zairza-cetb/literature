import server from "./app";
import { PORT } from "./util/secrets";

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});