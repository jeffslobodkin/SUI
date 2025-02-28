import { Transaction } from "@mysten/sui/transactions";
import { Button, Container, TextField } from "@radix-ui/themes";
import { useSignAndExecuteTransaction, useSuiClient } from "@mysten/dapp-kit";
import { useNetworkVariable } from "./networkConfig";
import ClipLoader from "react-spinners/ClipLoader";
import { useState } from "react";

export function CreatePlayer() {
  const [playerName, setPlayerName] = useState<string>("");
  const packageID = useNetworkVariable("packageId");
  const suiClient = useSuiClient();
  const {
    mutate: signAndExecute,
    isSuccess,
    isPending,
  } = useSignAndExecuteTransaction();

  function create() {
    const tx = new Transaction();

    tx.moveCall({
      arguments: [tx.pure.string(playerName)], // Changed to use tx.pure.string
      typeArguments: [],
      target: `${packageID}::league::create_player`,
    });

    console.log("Creating player with name:", playerName);
    
    signAndExecute(
      {
        transaction: tx,
      },
      {
        onSuccess: async ({ digest }) => {
          console.log("Transaction successful, digest:", digest);
          await suiClient.waitForTransaction({
            digest: digest,
            options: {
              showEffects: true,
            },
          });
          setPlayerName("");
        },
        onError: (error) => {
          console.error("Transaction failed:", error);
        },
      },
    );
  }

  return (
    <Container>
      <TextField.Root
          placeholder="Enter player name"
          value={playerName}
          onChange={(e) => setPlayerName(e.target.value)}
        />
      <Button
        size="3"
        onClick={create}
        disabled={isSuccess || isPending || !playerName.trim()}
      >
        {isSuccess || isPending ? <ClipLoader size={20} /> : "Create Player"}
      </Button>
    </Container>
  );
}