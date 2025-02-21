import React, { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

toast.configure();

const FreeFireTopUp = () => {
  const [uid, setUid] = useState("");
  const [amount, setAmount] = useState("");
  const [transactionId, setTransactionId] = useState("");

  const handleTopUp = async () => {
    if (!uid || !amount || !transactionId) {
      toast.error("অনুগ্রহ করে UID, ডায়মন্ড পরিমাণ এবং পেমেন্ট ট্রানজাকশন আইডি লিখুন");
      return;
    }
    try {
      const response = await fetch("https://your-backend.com/api/topup", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ uid, amount, transactionId }),
      });
      const data = await response.json();
      if (data.success) {
        toast.success("টপ-আপ সফল হয়েছে!");
      } else {
        toast.error("কিছু ভুল হয়েছে!");
      }
    } catch (error) {
      toast.error("সার্ভার এরর, পরে চেষ্টা করুন");
    }
  };

  return (
    <div className="flex items-center justify-center h-screen">
      <Card className="p-6 max-w-sm shadow-lg">
        <CardContent>
          <h2 className="text-xl font-bold mb-4">Free Fire Diamond Top-Up</h2>
          <Input
            type="text"
            placeholder="আপনার Free Fire UID দিন"
            value={uid}
            onChange={(e) => setUid(e.target.value)}
            className="mb-4"
          />
          <Input
            type="number"
            placeholder="ডায়মন্ড সংখ্যা"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="mb-4"
          />
          <Input
            type="text"
            placeholder="বিকাশ/নগদ ট্রানজাকশন আইডি"
            value={transactionId}
            onChange={(e) => setTransactionId(e.target.value)}
            className="mb-4"
          />
          <Button onClick={handleTopUp} className="w-full bg-blue-500 text-white">
            Top-Up করুন
          </Button>
        </CardContent>
      </Card>
    </div>
  );
};

export default FreeFireTopUp;
