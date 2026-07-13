import React, { useState, useEffect } from 'react';
import { School } from '../types';
import { supabase } from '../services/supabaseClient';

interface SchoolAutocompleteProps {
  value: string;
  onChange: (value: string, school?: School) => void;
  placeholder?: string;
  label?: string;
}

export const SchoolAutocomplete: React.FC<SchoolAutocompleteProps> = ({
  value,
  onChange,
  placeholder = 'Digite o nome da escola...',
  label = 'Nome da Escola',
}) => {
  console.log('[SchoolAutocomplete] 🎨 Component rendered with value:', `"${value}"`);

  const [inputValue, setInputValue] = useState(value);
  const [suggestions, setSuggestions] = useState<School[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setInputValue(value);
  }, [value]);

  const searchSchools = async (query: string) => {
    console.log('[SchoolAutocomplete] 🔍 Searching for:', `"${query}"`);

    if (query.length < 3) {
      console.log('[SchoolAutocomplete] Query too short, skipping search');
      setSuggestions([]);
      return;
    }

    setLoading(true);
    try {
      console.log('[SchoolAutocomplete] Executing Supabase RPC search_schools_unaccent...');
      const { data, error } = await supabase.rpc('search_schools_unaccent', { q: query });

      console.log('[SchoolAutocomplete] RPC result:', {
        found: data?.length || 0,
        error: (error as any)?.message,
        sample: data?.[0],
      });

      if (!error && data) {
        setSuggestions(data as School[]);
        setShowSuggestions(true);
        console.log('[SchoolAutocomplete] ✅ Showing', data.length, 'suggestions');
      } else {
        console.error('[SchoolAutocomplete] ❌ RPC failed:', error);
      }
    } catch (err) {
      console.error('[SchoolAutocomplete] ❌ Search exception:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    setInputValue(newValue);
    onChange(newValue);

    if (newValue.length >= 3) {
      searchSchools(newValue);
    } else {
      setSuggestions([]);
      setShowSuggestions(false);
    }
  };

  const handleSelectSchool = (school: School) => {
    console.log('[SchoolAutocomplete] 🎯 School selected:', {
      name: school.name,
      inep: school.inep_code,
      city: school.city,
      fullObject: school,
    });

    setInputValue(school.name);
    onChange(school.name, school);
    setShowSuggestions(false);
    setSuggestions([]);
  };

  return (
    <div className="relative">
      <input
        type="text"
        value={inputValue}
        onChange={handleInputChange}
        onFocus={() => suggestions.length > 0 && setShowSuggestions(true)}
        onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
        className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
        placeholder={placeholder}
      />

      {loading && (
        <div className="absolute right-4 top-10 text-slate-400">
          <div className="animate-spin rounded-full h-4 w-4 border-2 border-blue-500 border-t-transparent"></div>
        </div>
      )}

      {showSuggestions && suggestions.length > 0 && (
        <div className="absolute z-50 w-full mt-1 bg-white border border-slate-200 rounded-2xl shadow-lg max-h-64 overflow-y-auto">
          {suggestions.map((school) => (
            <button
              key={school.id}
              type="button"
              onClick={() => handleSelectSchool(school)}
              className="w-full px-5 py-3 text-left hover:bg-blue-50 transition-colors border-b border-slate-100 last:border-0 first:rounded-t-2xl last:rounded-b-2xl"
            >
              <div className="font-bold text-sm text-slate-800">{school.name}</div>
              <div className="text-xs text-slate-500 flex gap-3 mt-1">
                <span>INEP: {school.inep_code}</span>
                {school.city && <span>• {school.city}</span>}
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  );
};
