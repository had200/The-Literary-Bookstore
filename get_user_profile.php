<?php
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['email'])) {
    $email = $_GET['email'];

    // Connexion à la base de données
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "bookmanagement";

    $conn = new mysqli($servername, $username, $password, $dbname);

    // Vérifiez la connexion
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Obtenez les informations de l'utilisateur
    $sql = "SELECT u.id, u.name, u.email, f.product_id, c.product_id AS comment_product_id, c.comment
            FROM users u
            LEFT JOIN favorites f ON u.id = f.user_id
            LEFT JOIN comments c ON u.id = c.user_id
            WHERE u.email = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Récupérer les données de l'utilisateur
        $userData = [];
        $userData['favorites'] = [];
        $userData['comments'] = [];

        while ($row = $result->fetch_assoc()) {
            // Ajoutez le produit aux favoris
            if ($row['product_id'] !== null) {
                $userData['favorites'][] = $row['product_id'];
            }

            // Ajoutez les commentaires
            if ($row['comment_product_id'] !== null) {
                $userData['comments'][] = [
                    'product' => $row['comment_product_id'],
                    'comment' => $row['comment']
                ];
            }

            // Ajoutez les autres informations de l'utilisateur
            $userData['name'] = $row['name'];
            $userData['email'] = $row['email'];
        }

        // Réponse au format JSON
        echo json_encode(['success' => true, 'user' => $userData]);
    } else {
        echo json_encode(['success' => false, 'message' => 'User not found']);
    }

    // Fermer la connexion
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Email parameter is required']);
}
?>
