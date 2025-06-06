import React from 'react'
import { AddCarForm } from '../_components/add-car-form';


export const metadata = {
  title: "Cars | Vehiql Admin",
  description: "Manage cars in your marketplace",
};


export default function AddCarPage() {
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Add New Car</h1>
      <AddCarForm/>
    </div>
  );
}