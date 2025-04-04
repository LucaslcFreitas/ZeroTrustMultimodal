from core.idp_server import IDPServer
import logging

def main():

    server = IDPServer()
    
    try:
        server.start()
        logging.info("IDP server started!")
    except Exception as e:
        logging.error(f"Failed to start server: {str(e)}")
        exit(1)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    main()